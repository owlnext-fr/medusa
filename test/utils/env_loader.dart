import 'dart:io';

class EnvLoader {
  static Future<Map<String, String>> load(String fileName) async {
    final file = File(fileName);
    final lines = await file.readAsLines();

    final env = <String, String>{};

    for (var line in lines) {
      if (line.trim().isEmpty || line.startsWith('#')) continue;
      final parts = line.split('=');
      if (parts.length == 2) {
        env[parts[0].trim()] = parts[1].trim();
      }
    }
    return env;
  }
}
