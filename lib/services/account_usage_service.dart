import 'dart:convert';

import 'package:http/http.dart' as http;

class AccountUsageSummary {
  const AccountUsageSummary({
    required this.accountUuid,
    required this.totalBytes,
    required this.currentBalance,
    required this.syncDelaySeconds,
  });

  final String accountUuid;
  final int totalBytes;
  final double currentBalance;
  final int syncDelaySeconds;

  factory AccountUsageSummary.fromJson(Map<String, dynamic> json) {
    return AccountUsageSummary(
      accountUuid: json['accountUuid'] as String? ?? '',
      totalBytes: (json['totalBytes'] as num?)?.toInt() ?? 0,
      currentBalance: (json['currentBalance'] as num?)?.toDouble() ?? 0,
      syncDelaySeconds: (json['syncDelaySeconds'] as num?)?.toInt() ?? 0,
    );
  }
}

class AccountUsageService {
  AccountUsageService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<AccountUsageSummary> fetchUsageSummary({
    required String baseUrl,
    required String sessionToken,
  }) async {
    final response = await _httpClient.get(
      Uri.parse(
          '${baseUrl.replaceAll(RegExp(r'/$'), '')}/api/account/usage/summary'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $sessionToken',
      },
    );

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw StateError(payload['message'] as String? ??
          payload['error'] as String? ??
          'usage summary request failed');
    }

    return AccountUsageSummary.fromJson(payload);
  }
}
