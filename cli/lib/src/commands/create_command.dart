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
        allowed: [APIService.dio.name, APIService.http.name],
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
    Status.init(_logger);
    final brick = Brick.git(
      const GitPath(
        'https://git.geekyants.com/ruchika/flutter-starter-cli',
        path: 'bricks/flutter_starter',
      ),
    );
    final dir = Directory.current;
    final target = DirectoryGeneratorTarget(dir);
    final name = _name;
    final desc = _desc;
    final org = _org;
    final api = _api;
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
    Status.end('Project Created with ${fileCount.length} Files!!!');
    await onGenerateComplete(
        _logger, '${Directory.current.path}/$name', api, git);
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
    bool git,
  ) async {
    Status.start('Running Basic Setup...');
    await Cli.removeFiles(
      path: path,
      api: api,
    );
    Status.end('Basic Setup Completed!!!');

    Status.start('Adding dependencies...');
    await Cli.addPub(
      path: path,
      api: api,
    );
    Status.end('Dependencies Added!!!');

    Status.start('Running Pub Get...');
    await Cli.pubGet(
      path: path,
    );
    Status.end('Pub Get Completed!!!');

    if (git) {
      Status.start('Initialize Git...');
      await Cli.gitInit(
        path: path,
      );
      Status.end('Git Initialized!!!');
    }
  }
}
