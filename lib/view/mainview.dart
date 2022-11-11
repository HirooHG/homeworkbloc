
import 'package:flutter/material.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:homeworkbloc/modelview/nightswitchercubit.dart';
import 'package:homeworkbloc/modelview/pagemanager.dart';
import 'package:homeworkbloc/modelview/edt/EdtBloc.dart';
import 'package:homeworkbloc/modelview/discipline/disciplinesbloc.dart';
import 'package:homeworkbloc/modelview/homework/homeworksbloc.dart';
import 'disciplinesview.dart';
import 'edtview.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  var pages = [
    DisciplinesView(),
    EdtView()
  ];
  bool isInitEdt = false;
  bool isInitDiscipline = false;
  bool isInitHomework = false;

  @override
  Widget build(context) {

    if(!isInitEdt) {
      BlocProvider.of<EdtBLoc>(context).add(InitEvent());
      isInitEdt = true;
    }
    if(!isInitDiscipline) {
      BlocProvider.of<DisciplineBloc>(context).add(InitDisciplinesEvent());
      isInitDiscipline = true;
    }
    if(!isInitHomework) {
      BlocProvider.of<HomeworkBloc>(context).add(InitHomeworkEvent());
      isInitHomework = true;
    }

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
