import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

class CreateCommand extends Command<int> {
  CreateCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser
      ..addOption(
        'desc',
        help: 'The description for the project.',
        defaultsTo: 'A New Flutter Project.',
      )
      ..addOption(
        'org',
        help: 'The organization for the project.',
        defaultsTo: 'com.example',
      );
  }

  final Logger _logger;

  @override
  String get description => 'Creates a new flutter starter project.';

  @override
  String get name => 'create';

  @override
  Future<int> run() async {
    final brick = Brick.git(
      const GitPath(
        'https://git.geekyants.com/ruchika/flutter-starter-cli',
        path: 'bricks/flutter_starter',
      ),
    );
    final target = DirectoryGeneratorTarget(Directory.current);
    final name = _name;
    final desc = argResults!['desc'] as String? ?? '';
    final org = argResults!['org'] as String? ?? 'com.example$name';
    final generateProgress = _logger.progress('Project Creating...');
    final generator = await MasonGenerator.fromBrick(brick);
    final fileCount = await generator.generate(
      target,
      logger: _logger,
      vars: {
        'name': name,
        'desc': desc,
        'org': org,
      },
    );
    generateProgress
        .complete('Project Created with ${fileCount.length} Files!');
    return ExitCode.success.code;
  }

  String get _name {
    final args = argResults!.rest;
    if (args.isEmpty) {
      usageException('Please provide project name');
    }
    if (args.length > 1) {
      usageException('Please provide valid project name');
    }
    return args.first;
  }
}
