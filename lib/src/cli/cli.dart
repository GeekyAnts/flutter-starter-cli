import 'dart:io';

import 'package:path/path.dart';

import 'package:flutter_starter_cli/src/utils.dart';

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

  static _delete(target) {
    if (target.existsSync()) target.deleteSync(recursive: true);
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
    File file;
    Directory folder;
    folder = Directory(join(path, '.git'));
    await _delete(folder);
    final String apiSdk = join(path, 'lib', 'api_sdk');
    if (api == APIService.dio.name) {
      folder = Directory(join(apiSdk, 'http'));
      await _delete(folder);
      file = File(join(apiSdk, 'http_api_sdk.dart'));
      await _delete(file);
      folder = Directory(join(apiSdk, 'graphql'));
      await _delete(folder);
      file = File(join(apiSdk, 'graphql_api_sdk.dart'));
      await _delete(file);
    } else if (api == APIService.http.name) {
      folder = Directory(join(apiSdk, 'dio'));
      await _delete(folder);
      file = File(join(apiSdk, 'dio_api_sdk.dart'));
      await _delete(file);
      folder = Directory(join(apiSdk, 'graphql'));
      await _delete(folder);
      file = File(join(apiSdk, 'graphql_api_sdk.dart'));
      await _delete(file);
    } else if (api == APIService.graphql.name) {
      folder = Directory(join(apiSdk, 'http'));
      await _delete(folder);
      file = File(join(apiSdk, 'http_api_sdk.dart'));
      await _delete(file);
      folder = Directory(join(apiSdk, 'dio'));
      await _delete(folder);
      file = File(join(apiSdk, 'dio_api_sdk.dart'));
      await _delete(file);
    }
    if (!test) {
      folder = Directory(join(path, 'integration_test'));
      await _delete(folder);
      folder = Directory(join(path, 'test'));
      await _delete(folder);
    }
  }

  static Future<void> removePackages(String path, String api, bool test) async {
    var args = [];
    if (api == APIService.dio.name) {
      args
        ..add('http')
        ..add('http_interceptor')
        ..add('graphql_flutter');
    } else if (api == APIService.http.name) {
      args
        ..add('dio')
        ..add('retrofit')
        ..add('graphql_flutter');
    } else if (api == APIService.graphql.name) {
      args
        ..add('http')
        ..add('http_interceptor')
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
