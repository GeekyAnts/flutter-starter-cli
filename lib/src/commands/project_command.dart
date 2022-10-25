import 'package:args/command_runner.dart';

class ProjectCommand extends Command<int> {
  ProjectCommand();

  @override
  String get description => 'Commands related to the Project.';

  @override
  String get name => 'project';
}
