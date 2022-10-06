import 'dart:io';

class Cli {
  static Future<void> removeFiles({
    String path = '.',
    String api = 'http',
  }) async {
    await Process.run(
      'rm',
      ['-rf', 'lib/api_sdk/${api == "http" ? "dio" : "http"}'],
      workingDirectory: path,
    );
  }

  static Future<void> pubGet({
    String path = '.',
    String api = 'dio',
  }) async {
    if (api == 'dio') {
      await Process.run(
        'flutter',
        ['pub', 'add', 'dio', 'retrofit'],
        workingDirectory: path,
      );
    } else {
      await Process.run(
        'flutter',
        ['pub', 'add', 'http', 'http_interceptor'],
        workingDirectory: path,
      );
    }
    await Process.run(
      'flutter',
      ['pub', 'get'],
      workingDirectory: path,
    );
  }
}
