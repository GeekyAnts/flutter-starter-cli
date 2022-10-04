import 'package:bloc/bloc.dart';
import 'package:{{name}}/{{name}}.dart';

class UpdateThemeBloc extends Bloc<UpdateThemeEvent, UpdateThemeState> {
  UpdateThemeBloc() : super(const SetTheme(appTheme: AppTheme.light)) {
    on<UpdateThemeEvent>((event, emit) {
      if (event is UpdateTheme) {
        emit(SetTheme(appTheme: event.appTheme));
      }
    });
  }
}
