
import 'package:flutter/material.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkbloc/modelview/nightswitchercubit.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(context) {
    return BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
      builder: (context, nightSwitcherState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Homework app",
              style: TextStyle(
                color: nightSwitcherState.textDefault
              ),
            ),
            leading: DayNightSwitcherIcon(
              isDarkModeEnabled: nightSwitcherState.isDarkMode,
              onStateChanged: (_) {
                BlocProvider.of<NightSwitcherCubit>(context).change();
              },
            ),
          ),
          body: Container(

          ),
        );
      },
    );
  }
}