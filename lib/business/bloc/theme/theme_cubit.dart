import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit({ThemeMode initialMode = ThemeMode.dark}) : super(initialMode);

  bool get isDarkMode => state == ThemeMode.dark;

  void setDarkMode(bool enabled) {
    emit(enabled ? ThemeMode.dark : ThemeMode.light);
  }
}

