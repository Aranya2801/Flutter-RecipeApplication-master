part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  @override List<Object?> get props => [];
}
class ToggleThemeEvent extends ThemeEvent {}
class SetThemeEvent extends ThemeEvent {
  final ThemeMode mode;
  SetThemeEvent(this.mode);
  @override List<Object?> get props => [mode];
}
