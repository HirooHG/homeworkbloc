
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

class NightSwitcherCubit extends Cubit<NightSwitcherState> {
  NightSwitcherCubit() : super(NightSwitcherState(isDarkMode: true));

  change() => emit(NightSwitcherState(isDarkMode: !state.isDarkMode));
}
class NightSwitcherState {
  final bool isDarkMode;

  NightSwitcherState({required this.isDarkMode});

  final ThemeData light = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      color: Color(0xffFFFFFF),
      foregroundColor: Colors.blue
    ),
  );
  final ThemeData dark = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      color: Color(0xFF253341),
      foregroundColor: Color(0xffDDDDDD)
    ),
    scaffoldBackgroundColor: const Color(0xFF15202B),
  );

  final Color _textDefaultDark = const Color(0xffDDDDDD);
  final Color _textColorDark = const Color(0xfffaebd7);
  final Color _containerDark = const Color(0xffDDDDDD);

  final Color _textInContainerDark = const Color(0xFF253341);
  final Color _containerTextDark = const Color(0xFF253341);
  final Color _containerTextColorDark = const Color(0xFFfaebd7);


  final Color _textDefaultLight = const Color(0xFF253341);
  final Color _textColorLight = Colors.blue;
  final Color _containerLight = const Color(0xFF253341);

  final Color _textInContainerLight = const Color(0xffDDDDDD);
  final Color _containerTextLight = const Color(0xFF253341);
  final Color _containerTextColorLight = Colors.blue;

  Color get textDefault => (isDarkMode) ? _textDefaultDark : _textDefaultLight;
  Color get textColor => (isDarkMode) ? _textColorDark : _textColorLight;
  Color get container => (isDarkMode) ? _containerDark : _containerLight;

  Color get textInContainer => (isDarkMode) ? _textInContainerDark : _textInContainerLight;
  Color get containerText => (isDarkMode) ? _containerTextDark : _containerTextLight;
  Color get containerTextColor => (isDarkMode) ? _containerTextColorDark : _containerTextColorLight;

  ThemeMode get themeMode => (isDarkMode) ? ThemeMode.dark : ThemeMode.light;
}