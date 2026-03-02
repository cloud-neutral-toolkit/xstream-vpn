//go:build linux

package main

/*
#cgo LDFLAGS: -lX11
#include <stdlib.h>
#include <string.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>

static Display* disp = NULL;
static Window mainWin = 0;

static Window getMainWin() {
    return mainWin;
}

static Window findWindow(const char* name) {
    if (disp == NULL) {
        disp = XOpenDisplay(NULL);
        if (disp == NULL) return 0;
    }
    Atom clientList = XInternAtom(disp, "_NET_CLIENT_LIST", True);
    Atom type;
    int format;
    unsigned long nitems, bytes;
    unsigned char* data = NULL;
    if (XGetWindowProperty(disp, DefaultRootWindow(disp), clientList, 0, 1024, False, XA_WINDOW, &type, &format, &nitems, &bytes, &data) == Success && data) {
        Window* list = (Window*)data;
        for (unsigned long i=0; i<nitems; i++) {
            char* wname = NULL;
            if (XFetchName(disp, list[i], &wname) > 0) {
                if (wname && strcmp(wname, name)==0) {
                    mainWin = list[i];
                    if (wname) XFree(wname);
                    XFree(data);
                    return mainWin;
                }
                if (wname) XFree(wname);
            }
        }
        XFree(data);
    }
    return 0;
}

static int isIconic() {
    if (!disp || mainWin==0) return 0;
    Atom WM_STATE = XInternAtom(disp, "WM_STATE", True);
    Atom type; int format; unsigned long items, bytes; unsigned char* prop=NULL;
    if (XGetWindowProperty(disp, mainWin, WM_STATE, 0, 2, False, WM_STATE, &type, &format, &items, &bytes, &prop) == Success && prop) {
        long state = *(long*)prop;
        XFree(prop);
        return state == IconicState;
    }
    return 0;
}

static void hideWindow() {
    if (disp && mainWin) { XUnmapWindow(disp, mainWin); XFlush(disp); }
}

static void showWindow() {
    if (disp && mainWin) { XMapRaised(disp, mainWin); XFlush(disp); }
}
*/
import "C"
import (
	"encoding/json"
	"errors"
	"os"
	"path/filepath"
	"runtime"
	"sync"
	"time"
	"unsafe"

	"github.com/getlantern/systray"
	"github.com/xtls/libxray/xray"
)

var procMap sync.Map
var instMu sync.Mutex

func startXrayInternal(cfgData []byte) error {
	if xray.GetXrayState() {
		return errors.New("already running")
	}
	return xray.RunXrayFromJSON("", "", string(cfgData))
}

func stopXrayInternal() error {
	if !xray.GetXrayState() {
		return errors.New("not running")
	}
	return xray.StopXray()
}

func clearNodeRegistry() {
	procMap.Range(func(key, value any) bool {
		procMap.Delete(key)
		return true
	})
}

//export WriteConfigFiles
func WriteConfigFiles(xrayPathC, xrayContentC, servicePathC, serviceContentC, vpnPathC, vpnContentC, passwordC *C.char) *C.char {
	xrayPath := C.GoString(xrayPathC)
	xrayContent := C.GoString(xrayContentC)
	servicePath := C.GoString(servicePathC)
	serviceContent := C.GoString(serviceContentC)
	vpnPath := C.GoString(vpnPathC)
	vpnContent := C.GoString(vpnContentC)
	_ = passwordC

	if err := os.MkdirAll(filepath.Dir(xrayPath), 0755); err != nil {
		return C.CString("error:" + err.Error())
	}
	if err := os.WriteFile(xrayPath, []byte(xrayContent), 0644); err != nil {
		return C.CString("error:" + err.Error())
	}
	if err := os.MkdirAll(filepath.Dir(servicePath), 0755); err != nil {
		return C.CString("error:" + err.Error())
	}
	if err := os.WriteFile(servicePath, []byte(serviceContent), 0644); err != nil {
		return C.CString("error:" + err.Error())
	}
	if err := os.MkdirAll(filepath.Dir(vpnPath), 0755); err != nil {
		return C.CString("error:" + err.Error())
	}
	var existing []map[string]interface{}
	if data, err := os.ReadFile(vpnPath); err == nil {
		json.Unmarshal(data, &existing)
	}
	var newNodes []map[string]interface{}
	if err := json.Unmarshal([]byte(vpnContent), &newNodes); err == nil {
		existing = append(existing, newNodes...)
	} else {
		return C.CString("error:invalid vpn node content")
	}
	updated, _ := json.MarshalIndent(existing, "", "  ")
	if err := os.WriteFile(vpnPath, updated, 0644); err != nil {
		return C.CString("error:" + err.Error())
	}
	return C.CString("success")
}

//export StartNodeService
func StartNodeService(name *C.char) *C.char {
	instMu.Lock()
	defer instMu.Unlock()

	node := C.GoString(name)
	if _, ok := procMap.Load(node); ok && xray.GetXrayState() {
		return C.CString("success")
	}
	if xray.GetXrayState() {
		return C.CString("error:already running")
	}

	configPath := filepath.Join(os.TempDir(), node+".json")
	data, err := os.ReadFile(configPath)
	if err != nil {
		return C.CString("error:" + err.Error())
	}
	if err := startXrayInternal(data); err != nil {
		return C.CString("error:" + err.Error())
	}
	procMap.Store(node, true)
	return C.CString("success")
}

//export StopNodeService
func StopNodeService(name *C.char) *C.char {
	instMu.Lock()
	defer instMu.Unlock()

	node := C.GoString(name)
	if _, ok := procMap.Load(node); ok {
		if xray.GetXrayState() {
			if err := stopXrayInternal(); err != nil {
				return C.CString("error:" + err.Error())
			}
		}
		procMap.Delete(node)
		return C.CString("success")
	}
	if xray.GetXrayState() {
		if err := stopXrayInternal(); err != nil {
			return C.CString("error:" + err.Error())
		}
	}
	clearNodeRegistry()
	return C.CString("success")
}

//export CheckNodeStatus
func CheckNodeStatus(name *C.char) C.int {
	node := C.GoString(name)
	if _, ok := procMap.Load(node); ok && xray.GetXrayState() {
		return 1
	}
	return 0
}

//export PerformAction
func PerformAction(action, password *C.char) *C.char {
	act := C.GoString(action)
	if act == "isXrayDownloading" {
		return C.CString("0")
	}
	return C.CString("error:unsupported")
}

//export IsXrayDownloading
func IsXrayDownloading() C.int { return 0 }

//export FreeCString
func FreeCString(str *C.char) { C.free(unsafe.Pointer(str)) }

//export StartXray
func StartXray(configC *C.char) *C.char {
	instMu.Lock()
	defer instMu.Unlock()

	if xray.GetXrayState() {
		return C.CString("error:already running")
	}
	cfgData := []byte(C.GoString(configC))
	if err := startXrayInternal(cfgData); err != nil {
		return C.CString("error:" + err.Error())
	}
	return C.CString("success")
}

//export StopXray
func StopXray() *C.char {
	instMu.Lock()
	defer instMu.Unlock()

	if !xray.GetXrayState() {
		return C.CString("error:not running")
	}
	if err := stopXrayInternal(); err != nil {
		return C.CString("error:" + err.Error())
	}
	clearNodeRegistry()
	return C.CString("success")
}

// ---- System tray integration ----

var trayOnce sync.Once

func monitorMinimize() {
	for {
		if C.getMainWin() == 0 {
			cname := C.CString("xstream")
			C.findWindow(cname)
			C.free(unsafe.Pointer(cname))
		}
		if C.getMainWin() != 0 {
			if C.isIconic() != 0 {
				C.hideWindow()
			}
		}
		time.Sleep(500 * time.Millisecond)
	}
}

//export InitTray
func InitTray() {
	trayOnce.Do(func() {
		go func() {
			runtime.LockOSThread()
			systray.Run(func() {
				icon, err := os.ReadFile("data/flutter_assets/assets/logo.png")
				if err == nil {
					systray.SetIcon(icon)
				}
				mShow := systray.AddMenuItem("Show", "Show window")
				mQuit := systray.AddMenuItem("Quit", "Quit")
				go func() {
					for {
						select {
						case <-mShow.ClickedCh:
							if C.getMainWin() == 0 {
								cname := C.CString("xstream")
								C.findWindow(cname)
								C.free(unsafe.Pointer(cname))
							}
							if C.getMainWin() != 0 {
								C.showWindow()
							}
						case <-mQuit.ClickedCh:
							systray.Quit()
							return
						}
					}
				}()
				go monitorMinimize()
			}, func() {})
		}()
	})
}
