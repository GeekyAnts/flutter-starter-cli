import 'dart:io';

import 'package:path/path.dart';

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

  static Future<void> cloneProject(String path) async {
    await _run(
      'git',
      [
        'clone',
        'https://github.com/Geekyants/flutter-starter.git',
        '--branch',
        'development',
        '--single-branch',
        path
      ],
      path: path,
    );
  }

  static Future<void> removeFiles(String path, String api, bool test) async {
    Directory target;
    target = Directory(join(path, '.git'));
    await target.delete(recursive: true);
    if (api == 'dio') {
      target = Directory(join(path, 'lib', 'api_sdk', 'http'));
      await target.delete(recursive: true);
      target = Directory(join(path, 'lib', 'api_sdk', 'http_api_sdk.dart'));
      await target.delete(recursive: true);
    } else {
      target = Directory(join(path, 'lib', 'api_sdk', 'dio'));
      await target.delete(recursive: true);
      target = Directory(join(path, 'lib', 'api_sdk', 'dio_api_sdk.dart'));
      await target.delete(recursive: true);
    }
    if (!test) {
      target = Directory(join(path, 'integration_test'));
      await target.delete(recursive: true);
      target = Directory(join(path, 'test'));
      await target.delete(recursive: true);
    }
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
