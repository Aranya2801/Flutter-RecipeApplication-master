import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.system)) {
    on<ToggleThemeEvent>(_onToggle);
    on<SetThemeEvent>(_onSet);
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('theme_mode') ?? 'system';
    final mode = saved == 'dark' ? ThemeMode.dark
        : saved == 'light' ? ThemeMode.light : ThemeMode.system;
    add(SetThemeEvent(mode));
  }

  Future<void> _onToggle(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    final next = state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', next == ThemeMode.dark ? 'dark' : 'light');
    emit(ThemeState(themeMode: next));
  }

  Future<void> _onSet(SetThemeEvent event, Emitter<ThemeState> emit) async {
    emit(ThemeState(themeMode: event.mode));
  }
}
