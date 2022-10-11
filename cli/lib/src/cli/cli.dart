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

  static Future<void> removeFiles(String path, String api, bool test) async {
    var args = [];
    if (api == 'dio') {
      args
        ..add('lib/api_sdk/http')
        ..add('lib/api_sdk/http_api_sdk.dart');
    } else {
      args
        ..add('lib/api_sdk/dio')
        ..add('lib/api_sdk/dio_api_sdk.dart');
    }
    if (!test) {
      args
        ..add('integration_test')
        ..add('test');
    }
    await _run(
      'rm',
      ['-rf', ...args],
      path: path,
    );
  }

  static Future<void> removePackages(String path, String api, bool test) async {
    var args = [];
    if (api == 'dio') {
      args
        ..add('http')
        ..add('http_interceptor');
    } else {
      args
        ..add('dio')
        ..add('retrofit');
    }
    if (!test) {
      args
        ..add('bloc_test')
        ..add('mocktail');
    }
    await _run(
      'flutter',
      ['pub', 'remove', ...args],
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
