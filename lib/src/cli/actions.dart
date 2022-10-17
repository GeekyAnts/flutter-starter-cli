import 'dart:io';

import 'package:flutter_starter_cli/src/cli/cli.dart';
import 'package:flutter_starter_cli/src/utils.dart';

class Actions {
  static Future<void> createProject(String path) async {
    Status.start('Project Creating...');
    try {
      await Cli.cloneProject(path);
      Status.complete('Project Created!!!');
    } catch (_) {
      Status.fail('Project Creation Failed!!!');
    }
  }

  static Future<void> generateFiles(
    String path,
    String name,
    String desc,
    String org,
    String api,
    bool test,
  ) async {
    Status.start('Running Basic Setup...');
    try {
      await Cli.removeFiles(path, api, test);
      Status.complete('Basic Setup Completed!!!');
    } catch (_) {
      Status.fail('Setup Failed.');
    }
    await Future.wait(
      Directory(path)
          .listSync(recursive: true)
          .whereType<File>()
          .map((_) async {
        var file = _;
        try {
          final contents = await file.readAsString();
          file = await file.writeAsString(contents
              .replaceAll('flutter_starter', name)
              .replaceAll('A new Flutter project.', desc)
              .replaceAll('com.example', org)
              .replaceAll(
                  'api_sdk/dio_api_sdk.dart', 'api_sdk/${api}_api_sdk.dart'));
        } catch (_) {}
      }),
    );
  }

  static Future<void> setupPackages(String path, String api, bool test) async {
    Status.start('Adding Dependencies...');
    try {
      await Cli.removePackages(path, api, test);
      Status.complete('Dependencies Added!!!');
    } catch (_) {
      Status.fail('Pub Add Failed.');
    }
  }

  static Future<void> getPackages(String path) async {
    Status.start('Running Pub Get...');
    try {
      await Cli.getPackages(path);
      Status.complete('Pub Get Completed!!!');
    } catch (_) {
      Status.fail('Pub Get Failed.');
    }
  }

  static Future<void> initializeGit(String path, bool git) async {
    if (git) {
      Status.start('Initialize Git...');
      try {
        await Cli.initializeGit(path);
        Status.complete('Git Initialized!!!');
      } catch (_) {
        Status.fail('Git Not Installed.');
      }
    }
  }
}
