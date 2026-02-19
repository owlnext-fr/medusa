import 'package:medusa/api/mantis_api.dart';
import 'package:test/test.dart';

import '../utils/env_loader.dart';

void main() async {
  Map<String, String> env = await EnvLoader.load(".env.test");

  group('Testing StatusEndpoint', () {
    MantisApi api = MantisApi(env['BASE_URL']!, env['TOKEN']!);

    test('Ping should return true', () async {
      final result = await api.status.ping();
      expect(result, true);
    });
  });
}
