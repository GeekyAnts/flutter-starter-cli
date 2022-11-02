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

  static _delete(Directory target, [bool isFile = false]) {
    if (isFile || target.existsSync()) target.deleteSync(recursive: true);
  }

  static Future<void> cloneProject(String path, String state) async {
    await _run(
      'git',
      [
        'clone',
        'https://github.com/Geekyants/flutter-starter.git',
        '--branch',
        state,
        '--single-branch',
        path
      ],
      path: path,
    );
  }

  static Future<void> removeFiles(String path, String api, bool test) async {
    Directory target;
    target = Directory(join(path, '.git'));
    await _delete(target);
    if (api == 'dio') {
      target = Directory(join(path, 'lib', 'api_sdk', 'http'));
      await _delete(target);
      target = Directory(join(path, 'lib', 'api_sdk', 'http_api_sdk.dart'));
      await _delete(target, true);
    } else {
      target = Directory(join(path, 'lib', 'api_sdk', 'dio'));
      await _delete(target);
      target = Directory(join(path, 'lib', 'api_sdk', 'dio_api_sdk.dart'));
      await _delete(target, true);
    }
    if (!test) {
      target = Directory(join(path, 'integration_test'));
      await _delete(target);
      target = Directory(join(path, 'test'));
      await _delete(target);
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

  static Future<void> upgradeProject(String path, bool major) async {
    await _run(
      'flutter',
      ['pub', 'upgrade', major ? '--major-versions' : ''],
      path: path,
    );
  }
}
