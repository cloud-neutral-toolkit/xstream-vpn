import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:xstream/utils/tun_config_guard.dart';

void main() {
  group('guardTunInterfaceFieldsForWrite', () {
    test('removes non-utun interface fields on Apple platforms', () {
      final raw = jsonEncode({
        'inbounds': [
          {
            'protocol': 'tun',
            'settings': {
              'interfaceName': 'en0',
              'name': 'abc',
              'interface': 'tun0',
              'extra': true,
            },
          }
        ]
      });

      final result = guardTunInterfaceFieldsForWrite(raw);

      if (Platform.isMacOS || Platform.isIOS) {
        expect(result.removedFields, 3);
        final decoded = jsonDecode(result.json) as Map<String, dynamic>;
        final settings = (decoded['inbounds'] as List).first['settings']
            as Map<String, dynamic>;
        expect(settings.containsKey('interfaceName'), isFalse);
        expect(settings.containsKey('name'), isFalse);
        expect(settings.containsKey('interface'), isFalse);
        expect(settings['extra'], isTrue);
      } else {
        expect(result.removedFields, 0);
        expect(result.json, raw);
      }
    });

    test('keeps valid utun values', () {
      final raw = jsonEncode({
        'inbounds': [
          {
            'protocol': 'tun',
            'settings': {
              'interfaceName': 'utun2',
              'name': 'utun9',
              'interface': 'utun10',
            },
          }
        ]
      });

      final result = guardTunInterfaceFieldsForWrite(raw);
      final decoded = jsonDecode(result.json) as Map<String, dynamic>;
      final settings = (decoded['inbounds'] as List).first['settings']
          as Map<String, dynamic>;

      expect(settings['interfaceName'], 'utun2');
      expect(settings['name'], 'utun9');
      expect(settings['interface'], 'utun10');
      expect(result.removedFields, 0);
    });

    test('returns original payload when JSON is invalid', () {
      const raw = '{invalid-json';
      final result = guardTunInterfaceFieldsForWrite(raw);

      expect(result.removedFields, 0);
      expect(result.json, raw);
    });
  });
}
