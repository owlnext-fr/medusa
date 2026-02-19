import 'dart:io';

import 'package:medusa/core/medusa.dart';
import 'package:test/test.dart';

import '../utils/env_loader.dart';

void main() async {
  Map<String, String> env = await EnvLoader.load(".env.test");

  group('Testing StatusEndpoint', () {
    Medusa.initialize(
      baseUrl: env['BASE_URL']!,
      token: env['TOKEN']!,
      project: env['PROJECT']!,
      category: env['CATEGORY']!,
      browser: "chrome",
      os: "windows",
      device: "desktop",
      environment: "UAT",
    );

    test('Ping should return true when API is reachable', () async {
      bool result = await Medusa.ping();
      expect(result, isTrue);
    });

    test('Ping should return false when API is unreachable', () async {
      // Restore valid configuration for other tests
      int issueId = await Medusa.createIssue(
        path: "/test/path",
        summary: "Test Issue",
        description: "This is a test issue created during unit testing.",
        severity: "minor",
        fileData: await File('test.png').readAsBytes(),
      );

      // Expect a non-null issue ID from the successful creation
      expect(issueId, isNotNull);
    });
  });
}
