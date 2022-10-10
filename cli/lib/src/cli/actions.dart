import 'package:flutter_starter_cli/src/cli/cli.dart';
import 'package:flutter_starter_cli/src/utils.dart';

class Actions {
  static Future<void> setupFiles(String path, String api) async {
    Status.start('Running Basic Setup...');
    if (api == 'dio') {
      try {
        await Cli.removeHttpFiles(path);
        Status.complete('Basic Setup Completed!!!');
      } catch (_) {
        Status.fail('Setup Failed.');
      }
    } else {
      try {
        await Cli.removeDioFiles(path);
        Status.complete('Basic Setup Completed!!!');
      } catch (_) {
        Status.fail('Setup Failed.');
      }
    }
  }

  static Future<void> addPackages(String path, String api) async {
    Status.start('Adding Dependencies...');
    if (api == 'dio') {
      try {
        await Cli.removeHttpPackage(path);
        Status.complete('Dependencies Added!!!');
      } catch (_) {
        Status.fail('Pub Add Failed.');
      }
    } else {
      try {
        await Cli.removeDioPackage(path);
        Status.complete('Dependencies Added!!!');
      } catch (_) {
        Status.fail('Pub Add Failed.');
      }
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

  static Future<void> initializeGit(String path) async {
    Status.start('Initialize Git...');
    try {
      await Cli.initializeGit(path);
      Status.complete('Git Initialized!!!');
    } catch (_) {
      Status.fail('Git Not Installed.');
    }
  }
}
