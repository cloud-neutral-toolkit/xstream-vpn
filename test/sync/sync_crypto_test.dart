import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xstream/services/sync/sync_crypto.dart';

void main() {
  group('SyncCrypto', () {
    final secret = Uint8List.fromList(List<int>.generate(32, (i) => i + 1));
    final nonce = Uint8List.fromList(List<int>.generate(24, (i) => 24 - i));

    test('encrypt/decrypt round trip preserves plaintext bytes', () async {
      final plaintext = utf8.encode('xstream-sync-payload');

      final cipher = await SyncCrypto.encrypt(
        secret: secret,
        nonce: nonce,
        plaintext: plaintext,
      );

      final decrypted = await SyncCrypto.decrypt(
        secret: secret,
        nonce: nonce,
        cipherText: cipher,
      );

      expect(decrypted, Uint8List.fromList(plaintext));
    });

    test('decrypt throws StateError for ciphertext shorter than MAC', () async {
      await expectLater(
        () => SyncCrypto.decrypt(
          secret: secret,
          nonce: nonce,
          cipherText: const <int>[1, 2, 3],
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('decrypt fails authentication with wrong secret', () async {
      final plaintext = utf8.encode('integrity-check');
      final cipher = await SyncCrypto.encrypt(
        secret: secret,
        nonce: nonce,
        plaintext: plaintext,
      );

      final wrongSecret =
          Uint8List.fromList(List<int>.filled(32, 7, growable: false));

      await expectLater(
        () => SyncCrypto.decrypt(
          secret: wrongSecret,
          nonce: nonce,
          cipherText: cipher,
        ),
        throwsA(isA<SecretBoxAuthenticationError>()),
      );
    });
  });
}
