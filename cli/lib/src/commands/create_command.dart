import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

import 'package:flutter_starter_cli/src/cli/actions.dart';
import 'package:flutter_starter_cli/src/command_runner.dart';
import 'package:flutter_starter_cli/src/utils.dart';

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
        allowed: [APIService.dio.name, APIService.http.name],
      )
      ..addFlag(
        'test',
        abbr: 't',
        help: 'Setup Test Cases.',
        defaultsTo: null,
      )
      ..addFlag(
        'git',
        abbr: 'g',
        help: 'Initialize Git Repository.',
        defaultsTo: null,
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
        'https://github.com/GeekyAnts/flutter-starter-cli',
        path: 'bricks/flutter_starter',
      ),
    );
    final dir = Directory.current;
    final target = DirectoryGeneratorTarget(dir);
    final name = _name;
    final desc = _desc;
    final org = _org;
    final api = _api;
    final test = _test;
    final git = _git;
    Status.start('Project Creating...');
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
    Status.complete('Project Created with ${fileCount.length} Files!!!');
    await onGenerateComplete(
      _logger,
      '${Directory.current.path}/$name',
      api,
      test,
      git,
    );
    _logger.success('Your Project is Ready to Use 🚀');
    return ExitCode.success.code;
  }

  String get _name {
    final args = argResults!.rest;
    if (args.isEmpty) {
      return _logger.prompt(
        'Name of the Project?',
        defaultValue: 'counter',
      );
    }
    return args.first;
  }

  String get _api {
    return argResults?['api'] ??
        _logger.chooseOne(
          'Select the API Service',
          choices: [APIService.dio.name, APIService.http.name],
          defaultValue: APIService.dio.name,
        );
  }

  String get _desc {
    return argResults?['desc'] ??
        _logger.prompt(
          'Please Enter the Description',
          defaultValue: 'A New Flutter Project.',
        );
  }

  String get _org {
    return argResults?['org'] ??
        _logger.prompt(
          'Please Enter the Organization',
          defaultValue: 'com.example',
        );
  }

  bool get _test {
    return argResults?['test'] ??
        _logger.confirm(
          'Whether Test Cases Required?',
          defaultValue: true,
        );
  }

  bool get _git {
    return argResults?['git'] ??
        _logger.confirm(
          'Initialize Git Repository?',
          defaultValue: false,
        );
  }

  Future<void> onGenerateComplete(
    Logger logger,
    String path,
    String api,
    bool test,
    bool git,
  ) async {
    await Actions.setupFiles(path, api, test);
    await Actions.setupPackages(path, api, test);
    await Actions.getPackages(path);
    if (git) await Actions.initializeGit(path);
  }
}
