import 'package:flutter_test/flutter_test.dart';
import 'package:xstream/services/sync/xray_config_writer.dart';

void main() {
  group('XrayConfigWriter.extractOutboundIdentity', () {
    test('extracts stable identity from proxy outbound', () {
      const json = '''
{
  "outbounds": [
    {
      "tag": "proxy",
      "protocol": "vless",
      "settings": {
        "vnext": [
          {
            "address": "57.183.19.25",
            "port": 443,
            "users": [
              { "id": "18d270a9-533d-4b13-b3f1-e7f55540a9b2" }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "xhttp",
        "security": "tls",
        "tlsSettings": {
          "serverName": "jp-xhttp.svc.plus"
        }
      }
    }
  ]
}
''';

      final identity = XrayConfigWriter.extractOutboundIdentity(json);

      expect(
        identity,
        'vless|57.183.19.25|443|18d270a9-533d-4b13-b3f1-e7f55540a9b2|xhttp|tls|jp-xhttp.svc.plus',
      );
    });

    test('returns null when proxy outbound is missing', () {
      const json = '{"outbounds":[{"tag":"direct","protocol":"freedom"}]}';
      expect(XrayConfigWriter.extractOutboundIdentity(json), isNull);
    });
  });
}
