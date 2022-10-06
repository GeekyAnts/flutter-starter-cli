import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_starter_cli/src/cli.dart';
import 'package:flutter_starter_cli/src/command_runner.dart';
import 'package:flutter_starter_cli/src/utils.dart';
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
      )
      ..addOption(
        'api',
        abbr: 'a',
        help: 'The API service for the project.',
        defaultsTo: APIService.dio.name,
        allowed: [APIService.dio.name, APIService.http.name],
      );
  }

  final Logger _logger;

  @override
  String get description => 'Creates a new flutter starter project.';

  @override
  String get name => 'create';

  @override
  String get invocation => '$executableName $name <project_name>';

  @override
  Future<int> run() async {
    final brick = Brick.git(
      const GitPath(
        'https://git.geekyants.com/ruchika/flutter-starter-cli',
        path: 'bricks/flutter_starter',
      ),
    );
    final dir = Directory.current;
    final target = DirectoryGeneratorTarget(dir);
    final name = _name;
    final desc = argResults!['desc'];
    final org = argResults!['org'];
    final api = argResults!['api'];
    final generateProgress = _logger.progress('Project Creating...');
    final generator = await MasonGenerator.fromBrick(brick);
    final fileCount = await generator.generate(
      target,
      logger: _logger,
      vars: {
        'name': name,
        'desc': desc,
        'org': org,
        'api': api,
      },
    );
    await onGenerateComplete(_logger, '${Directory.current.path}/$name', api);
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

  Future<void> onGenerateComplete(
    Logger logger,
    String path,
    String api,
  ) async {
    await Cli.removeFiles(
      path: path,
      api: api,
    );
    await Cli.pubGet(
      path: path,
      api: api,
    );
  }
}
