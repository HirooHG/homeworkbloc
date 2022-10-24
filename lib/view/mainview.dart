
import 'package:flutter/material.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:homeworkbloc/modelview/nightswitchercubit.dart';
import 'package:homeworkbloc/modelview/pagemanager.dart';
import 'disciplinesview.dart';
import 'edtview.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  var pages = [
    DisciplinesView(),
    EdtView()
  ];

  @override
  Widget build(context) {
    return BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
      builder: (context, nightSwitcherState) {
        return BlocBuilder<PageManagerCubit, int>(
          builder: (context, pageManagerState) {
            return Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: nightSwitcherState.textInContainer,
                currentIndex: pageManagerState,
                onTap: (value) {
                  BlocProvider.of<PageManagerCubit>(context).change(value);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.mode),
                    label: "Discipline"
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.edit_calendar),
                    label: "Edt"
                  ),
                ],
              ),
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
              body: pages[pageManagerState],
            );
          },
        );
      },
    );
  }
}
