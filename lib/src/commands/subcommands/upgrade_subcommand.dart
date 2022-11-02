import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import 'package:flutter_starter_cli/src/cli/actions.dart';

class ProjectUpgradeSubcommand extends Command<int> {
  ProjectUpgradeSubcommand() {
    argParser.addFlag(
      'major',
      abbr: 'm',
      help: 'Upgrade major versions.',
      defaultsTo: false,
    );
  }

  @override
  String get description => 'Upgrade the project dependencies.';

  @override
  String get name => 'upgrade';

  @override
  Future<int> run() async {
    final path = Directory.current.path;
    final major = _major;
    await Actions.upgradeProject(path, major);
    return ExitCode.success.code;
  }

  bool get _major {
    return argResults?['major'];
  }
}
