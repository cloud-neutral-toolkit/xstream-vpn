import 'package:flutter_test/flutter_test.dart';
import 'package:xstream/services/sync/desktop_sync_service.dart';

void main() {
  group('DesktopSyncService.shouldApplySyncPayload', () {
    test('applies when changed and config version is newer', () {
      final shouldApply = DesktopSyncService.shouldApplySyncPayload(
        changed: true,
        configVersion: 11,
        lastConfigVersion: 10,
        manual: false,
        hasRenderablePayload: false,
      );

      expect(shouldApply, isTrue);
    });

    test('skips when changed but config version is not newer in auto mode', () {
      final shouldApply = DesktopSyncService.shouldApplySyncPayload(
        changed: true,
        configVersion: 10,
        lastConfigVersion: 10,
        manual: false,
        hasRenderablePayload: true,
      );

      expect(shouldApply, isFalse);
    });

    test('applies manual sync when same version but payload is present', () {
      final shouldApply = DesktopSyncService.shouldApplySyncPayload(
        changed: true,
        configVersion: 10,
        lastConfigVersion: 10,
        manual: true,
        hasRenderablePayload: true,
      );

      expect(shouldApply, isTrue);
    });

    test('skips manual sync when payload is absent', () {
      final shouldApply = DesktopSyncService.shouldApplySyncPayload(
        changed: true,
        configVersion: 10,
        lastConfigVersion: 10,
        manual: true,
        hasRenderablePayload: false,
      );

      expect(shouldApply, isFalse);
    });

    test('always skips when server says not changed', () {
      final shouldApply = DesktopSyncService.shouldApplySyncPayload(
        changed: false,
        configVersion: 99,
        lastConfigVersion: 1,
        manual: true,
        hasRenderablePayload: true,
      );

      expect(shouldApply, isFalse);
    });
  });
}
