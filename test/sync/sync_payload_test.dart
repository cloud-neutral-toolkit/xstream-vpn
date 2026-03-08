import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:xstream/services/sync/sync_payload.dart';

void main() {
  group('SyncRequest', () {
    test('toBytes encodes fixed-layout header and tail fields', () {
      final deviceFingerprint =
          Uint8List.fromList(List<int>.generate(32, (i) => i));
      final nonce = Uint8List.fromList(List<int>.generate(24, (i) => 100 + i));
      const clientVersion = '1.2.3';
      const ts = 1700000000;
      const lastConfigVersion = 42;

      final request = SyncRequest(
        version: 1,
        deviceFingerprint: deviceFingerprint,
        clientVersion: clientVersion,
        nonce: nonce,
        timestamp: ts,
        lastConfigVersion: lastConfigVersion,
      );

      final bytes = request.toBytes();
      const expectedLength = 1 + 32 + 1 + clientVersion.length + 24 + 8 + 4;
      expect(bytes.length, expectedLength);

      expect(bytes[0], 1);
      expect(bytes.sublist(1, 33), deviceFingerprint);
      expect(bytes[33], clientVersion.length);
      expect(utf8.decode(bytes.sublist(34, 39)), clientVersion);
      expect(bytes.sublist(39, 63), nonce);
    });

    test('toBytes throws when clientVersion exceeds 255 bytes', () {
      final request = SyncRequest(
        version: 1,
        deviceFingerprint: Uint8List.fromList(List<int>.filled(32, 1)),
        clientVersion: 'a' * 256,
        nonce: Uint8List.fromList(List<int>.filled(24, 2)),
        timestamp: 1,
        lastConfigVersion: 1,
      );

      expect(request.toBytes, throwsArgumentError);
    });
  });

  group('parseSyncResponse', () {
    Uint8List buildResponse({
      required int version,
      required int statusByte,
      required int configVersion,
      required List<int> configBytes,
      String? metadata,
    }) {
      final builder = BytesBuilder();
      builder.add([version & 0xFF, statusByte & 0xFF]);

      final versionBuf = ByteData(4)..setInt32(0, configVersion, Endian.big);
      builder.add(versionBuf.buffer.asUint8List());

      final lenBuf = ByteData(4)..setUint32(0, configBytes.length, Endian.big);
      builder.add(lenBuf.buffer.asUint8List());
      builder.add(configBytes);

      if (metadata != null) {
        final metaBytes = utf8.encode(metadata);
        final metaLen = ByteData(2)..setUint16(0, metaBytes.length, Endian.big);
        builder.add(metaLen.buffer.asUint8List());
        builder.add(metaBytes);
      }

      return builder.toBytes();
    }

    test('decodes ok response with metadata', () {
      final bytes = buildResponse(
        version: 1,
        statusByte: 0,
        configVersion: 9,
        configBytes: const [31, 139, 8, 0],
        metadata: '{"plan":"pro"}',
      );

      final parsed = parseSyncResponse(bytes);
      expect(parsed.version, 1);
      expect(parsed.status, SyncResponseStatus.ok);
      expect(parsed.configVersion, 9);
      expect(parsed.xrayConfigGzip, Uint8List.fromList(const [31, 139, 8, 0]));
      expect(parsed.subscriptionMetadata, '{"plan":"pro"}');
    });

    test('maps unknown status to error', () {
      final bytes = buildResponse(
        version: 1,
        statusByte: 7,
        configVersion: 0,
        configBytes: const [],
      );

      final parsed = parseSyncResponse(bytes);
      expect(parsed.status, SyncResponseStatus.error);
    });

    test('throws when xray config length is truncated', () {
      final bytes = Uint8List.fromList([
        1,
        0,
        0,
        0,
        0,
        1, // configVersion
        0,
        0,
        0,
        5, // expects 5 bytes
        1,
        2, // only 2 bytes
      ]);

      expect(() => parseSyncResponse(bytes), throwsStateError);
    });

    test('throws when metadata length is truncated', () {
      final response = buildResponse(
        version: 1,
        statusByte: 0,
        configVersion: 1,
        configBytes: const [],
      );
      final broken = BytesBuilder()
        ..add(response)
        ..add(const [0, 4]) // metadata len = 4
        ..add(const [65, 66]); // only 2 bytes

      expect(() => parseSyncResponse(broken.toBytes()), throwsStateError);
    });
  });
}
