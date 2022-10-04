import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{name}}/{{name}}.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.instance.init();
  final authenticationService = AuthenticationRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) => AuthenticationBloc(
            authenticationService: authenticationService,
          ),
        ),
        BlocProvider<UpdateThemeBloc>(
          create: (BuildContext context) => UpdateThemeBloc(),
        ),
      ],
      child: const App(),
    ),
  );
}
