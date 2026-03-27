.PHONY: help
help: ## Show this help message
	@echo "XStream VPN Build System"
	@echo ""
	@echo "Usage: make <target> [ARCH=<arch>]"
	@echo ""
	@echo "Platform targets:"
	@echo "  build-macos-arm64   Build macOS ARM64 (Apple Silicon) release + DMG"
	@echo "  build-macos-x64     Build macOS x64 release + DMG"
	@echo "  build-windows-x64   Build Windows x64 release"
	@echo "  build-linux-x64     Build Linux x64 release"
	@echo "  build-ios-ipa       Build iOS IPA (requires macOS)"
	@echo "  build-android-apk   Build Android APK"
	@echo ""
	@echo "Utility targets:"
	@echo "  analyze             Run Flutter static analysis"
	@echo "  format              Format Dart code"
	@echo "  clean               Clean build artifacts"
	@echo "  sync-macos-config   Sync pubspec.yaml version to macOS config"



DIR := $(shell pwd)
FLUTTER := flutter
GO := go

VERSION := $(shell grep "^version:" pubspec.yaml | cut -d: -f2 | tr -d ' ')
BUILD := $(shell echo "$(VERSION)" | cut -d+ -f2)
MAJOR := $(shell echo "$(VERSION)" | cut -d. -f1)
MINOR := $(shell echo "$(VERSION)" | cut -d. -f2)
PATCH := $(shell echo "$(VERSION)" | cut -d. -f3 | cut -d+ -f1)

BRANCH := $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
BUILD_ID := $(shell git rev-parse --short HEAD 2>/dev/null || echo "0000000")
BUILD_DATE := $(shell date '+%Y-%m-%d')

DART_DEFINES := --dart-define=BRANCH_NAME=$(BRANCH) --dart-define=BUILD_ID=$(BUILD_ID) --dart-define=BUILD_DATE=$(BUILD_DATE)

export PATH := /opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$(PATH)

$(shell mkdir -p build/linux/x64/release/bundle/lib)
$(shell mkdir -p build/windows/x64/runner/Release)
$(shell mkdir -p build/app/outputs/flutter-apk)
$(shell mkdir -p build/ios/ipa)
$(shell mkdir -p build/ios/iphoneos)

check-flutter:
	@which $(FLUTTER) >/dev/null 2>&1 || { echo "Flutter not found. Install Flutter SDK first."; exit 1; }

check-go:
	@which $(GO) >/dev/null 2>&1 || { echo "Go not found. Install Go 1.20+ first."; exit 1; }

check-macos:
	@if [ "$$(uname -s)" != "Darwin" ]; then \
		echo "This target requires macOS"; \
		exit 1; \
	fi

check-git-submodules:
	@if [ ! -d "libXray" ] || [ ! -f "libXray/go.mod" ]; then \
		echo "libXray submodule not initialized. Run:"; \
		echo "  git submodule update --init --recursive libXray"; \
		exit 1; \
	fi

pub-get: check-flutter
	$(FLUTTER) pub get

sync-macos-config: check-flutter check-macos
	@echo ">>> Syncing version $(VERSION)+$(BUILD) to macOS config"
	$(FLUTTER) pub get
	@cd macos && \
		$(FLUTTER) build macos --version 2>/dev/null || true

build-macos-arm64: check-flutter check-macos check-git-submodules
	@echo ">>> Building macOS ARM64 (Apple Silicon) release"
	./build_scripts/build_ios_xray.sh || true
	$(FLUTTER) build macos --release --dart-define=FLUTTER_BUILD_NAME="$(VERSION)+$(BUILD)"
	@echo ">>> Build complete: build/macos/Build/Products/Release/xstream.app"

build-macos-x64: check-flutter check-macos check-git-submodules
	@echo ">>> Building macOS x64 release"
	./build_scripts/build_ios_xray.sh || true
	ARCHFLAGS="-arch x86_64" $(FLUTTER) build macos --release --dart-define=FLUTTER_BUILD_NAME="$(VERSION)+$(BUILD)"
	@echo ">>> Build complete: build/macos/Build/Products/Release/xstream.app"

build-windows-x64: check-flutter check-go
	@echo ">>> Building Windows x64 release"
	./build_scripts/build_windows.sh
	$(FLUTTER) build windows --release $(DART_DEFINES)
	@cp bindings/libgo_native_bridge.dll build/windows/x64/runner/Release/ 2>/dev/null || true
	@echo ">>> Build complete: build/windows/x64/runner/Release/xstream.exe"

build-linux-x64: check-flutter check-go
	@echo ">>> Building Linux x64 release"
	./build_scripts/build_linux.sh
	CC=/snap/flutter/current/usr/bin/clang \
	CXX=/snap/flutter/current/usr/bin/clang++ \
	$(FLUTTER) build linux --release -v $(DART_DEFINES)
	@cp linux/lib/libgo_native_bridge.so build/linux/x64/release/bundle/lib/ 2>/dev/null || true
	@echo ">>> Build complete: build/linux/x64/release/bundle/xstream"

build-ios-ipa: check-flutter check-macos check-git-submodules
	@echo ">>> Building iOS IPA"
	./build_scripts/build_ios_ipa.sh
	@echo ">>> IPA ready: build/ios/ipa/XStream.ipa"

build-android-apk: check-flutter check-go check-git-submodules
	@echo ">>> Building Android APK"
	./build_scripts/build_android_apk.sh
	@echo ">>> APK ready: build/app/outputs/flutter-apk/app-release.apk"

analyze: check-flutter
	$(FLUTTER) analyze

format: check-flutter
	$(FLUTTER) format .

clean:
	$(FLUTTER) clean
	rm -rf build/
	rm -rf linux/lib/
	rm -rf bindings/libgo_native_bridge.*
	rm -rf android/app/src/main/jniLibs/
	rm -rf ios/Flutter/Flutter.framework
	rm -rf ios/Flutter/Flutter.podspec
	rm -rf ios/Flutter/App.framework
	rm -rf .dart_tool/
	rm -rf *.lock
	find . -name "*.g.dart" -delete 2>/dev/null || true
	find . -name "*.freezed.dart" -delete 2>/dev/null || true

package-linux-deb:
	./build_scripts/package_linux_deb.sh

package-linux-rpm:
	./build_scripts/package_linux_rpm.sh

package-linux-bundle:
	./build_scripts/package_linux_bundle.sh

package-windows-bundle:
	pwsh -File ./build_scripts/package_windows_bundle.ps1

package-windows-msi:
	pwsh -File ./build_scripts/package_windows_msi.ps1

package-android-apk:
	$(FLUTTER) build apk --release $(DART_DEFINES)

test:
	$(FLUTTER) test

run:
	$(FLUTTER) run
