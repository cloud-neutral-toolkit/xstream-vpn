import 'dart:convert';
import 'dart:io';

class TunConfigGuardResult {
  final String json;
  final int removedFields;

  const TunConfigGuardResult({
    required this.json,
    required this.removedFields,
  });
}

TunConfigGuardResult guardTunInterfaceFieldsForWrite(String rawJson) {
  if (!(Platform.isMacOS || Platform.isIOS)) {
    return TunConfigGuardResult(json: rawJson, removedFields: 0);
  }

  final dynamic decoded;
  try {
    decoded = jsonDecode(rawJson);
  } catch (_) {
    return TunConfigGuardResult(json: rawJson, removedFields: 0);
  }

  if (decoded is! Map<String, dynamic>) {
    return TunConfigGuardResult(json: rawJson, removedFields: 0);
  }

  final dynamic inboundsRaw = decoded['inbounds'];
  if (inboundsRaw is! List) {
    return TunConfigGuardResult(json: rawJson, removedFields: 0);
  }

  int removedFields = 0;
  final utunPattern = RegExp(r'^utun\d+$');
  final normalizedInbounds = <dynamic>[];

  for (final inbound in inboundsRaw) {
    if (inbound is! Map) {
      normalizedInbounds.add(inbound);
      continue;
    }

    final normalizedInbound = Map<String, dynamic>.from(
      inbound.cast<Object?, Object?>(),
    );
    final protocol = normalizedInbound['protocol'];
    final settingsRaw = normalizedInbound['settings'];

    if (protocol == 'tun' && settingsRaw is Map) {
      final normalizedSettings = Map<String, dynamic>.from(
        settingsRaw.cast<Object?, Object?>(),
      );
      for (final key in const ['interfaceName', 'name', 'interface']) {
        if (!normalizedSettings.containsKey(key)) continue;
        final value = normalizedSettings[key];
        if (value is String && utunPattern.hasMatch(value)) continue;
        normalizedSettings.remove(key);
        removedFields++;
      }
      normalizedInbound['settings'] = normalizedSettings;
    }

    normalizedInbounds.add(normalizedInbound);
  }

  if (removedFields == 0) {
    return TunConfigGuardResult(json: rawJson, removedFields: 0);
  }

  final normalizedRoot = Map<String, dynamic>.from(decoded);
  normalizedRoot['inbounds'] = normalizedInbounds;
  final normalizedJson =
      const JsonEncoder.withIndent('  ').convert(normalizedRoot);

  return TunConfigGuardResult(
    json: normalizedJson,
    removedFields: removedFields,
  );
}
