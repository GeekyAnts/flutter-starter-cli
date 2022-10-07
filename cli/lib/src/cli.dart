import 'dart:io';

class Cli {
  static Future<void> removeFiles({
    String path = '.',
    String api = 'http',
  }) async {
    await Process.run(
      'rm',
      [
        '-rf',
        'lib/api_sdk/${api == "http" ? "dio" : "http"}',
        'lib/api_sdk/${api == "http" ? "dio" : "http"}_api_sdk.dart',
      ],
      workingDirectory: path,
    );
  }

  static Future<void> addPub({
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
  }

  static Future<void> pubGet({
    String path = '.',
  }) async {
    await Process.run(
      'flutter',
      ['pub', 'get'],
      workingDirectory: path,
    );
  }

  static Future<void> gitInit({
    String path = '.',
  }) async {
    await Process.run(
      'git',
      ['init'],
      workingDirectory: path,
    );
  }
}
