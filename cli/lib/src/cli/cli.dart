import 'dart:io';

class Cli {
  static Future<ProcessResult> _run(
    String cmd,
    List<String> args, {
    String? path,
  }) async {
    final result = await Process.run(
      cmd,
      args,
      workingDirectory: path,
      runInShell: true,
    );
    return result;
  }

  static Future<void> removeDioFiles(String path) async {
    await _run(
      'rm',
      [
        '-rf',
        'lib/api_sdk/dio',
        'lib/api_sdk/dio_api_sdk.dart',
      ],
      path: path,
    );
  }

  static Future<void> removeHttpFiles(String path) async {
    await _run(
      'rm',
      [
        '-rf',
        'lib/api_sdk/http',
        'lib/api_sdk/http_api_sdk.dart',
      ],
      path: path,
    );
  }

  static Future<void> removeDioPackage(String path) async {
    await _run(
      'flutter',
      ['pub', 'remove', 'dio', 'retrofit'],
      path: path,
    );
  }

  static Future<void> removeHttpPackage(String path) async {
    await _run(
      'flutter',
      ['pub', 'remove', 'http', 'http_interceptor'],
      path: path,
    );
  }

  static Future<void> getPackages(String path) async {
    await _run(
      'flutter',
      ['pub', 'get'],
      path: path,
    );
  }

  static Future<void> initializeGit(String path) async {
    await _run(
      'git',
      ['init'],
      path: path,
    );
  }
}
