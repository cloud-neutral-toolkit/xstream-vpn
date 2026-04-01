import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:xstream/services/account_usage_service.dart';

void main() {
  test('loads usage summary from accounts service', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/account/usage/summary');
      expect(request.headers['authorization'], 'Bearer session-token');
      return http.Response(
        jsonEncode({
          'accountUuid': 'acct-1',
          'totalBytes': 384,
          'currentBalance': 88.5,
          'syncDelaySeconds': 60,
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final service = AccountUsageService(httpClient: client);
    final summary = await service.fetchUsageSummary(
      baseUrl: 'https://accounts.svc.plus',
      sessionToken: 'session-token',
    );

    expect(summary.accountUuid, 'acct-1');
    expect(summary.totalBytes, 384);
    expect(summary.currentBalance, 88.5);
    expect(summary.syncDelaySeconds, 60);
  });
}
