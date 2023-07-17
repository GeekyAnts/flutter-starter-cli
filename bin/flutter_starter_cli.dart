import 'dart:io';

import 'package:flutter_starter_cli/src/command_runner.dart';

Future<void> main(List<String> args) async {
  await _flushThenExit(await FlutterStarterCliCommandRunner().run(args));
}

Future<void> _flushThenExit(int status) {
  return Future.wait<void>([stdout.close(), stderr.close()])
      .then<void>((_) => exit(status));
}
