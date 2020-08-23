part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  ThemeState(this.themeMode) : assert(themeMode != null);

  @override
  List<Object> get props => [themeMode];
}
