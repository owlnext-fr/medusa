import 'dart:io';

import 'package:medusa/api/mantis_api.dart';
import 'package:test/test.dart';

import '../utils/env_loader.dart';

void main() async {
  Map<String, String> env = await EnvLoader.load(".env.test");

  group('Testing StatusEndpoint', () {
    MantisApi api = MantisApi(
      env['BASE_URL']!,
      env['TOKEN']!,
      browser: "chrome",
      os: "windows",
      device: "desktop",
      environment: "UAT",
    );

    String? issueId;

    test('Sending a full issue', () async {
      final result = await api.issues.create(
        summary: 'Test Issue from Medusa',
        description: 'This issue was created as part of a test case.',
        project: env['PROJECT']!,
        category: env['CATEGORY']!,
        severity: 'minor',
      );

      expect(result.isNotEmpty, true);
      issueId = result['issue']['id'].toString();
    });

    test('Adding screenshot to issue', () async {
      final result = await api.issues.attachFile(
        issueId!,
        'screenshot.png',
        await File('test.png').readAsBytes(),
      );

      expect(result, true);
    });
  });
}
