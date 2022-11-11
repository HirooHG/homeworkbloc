
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkbloc/modelview/homework/homeworksbloc.dart';

import 'mainview.dart';
import 'package:homeworkbloc/modelview/calendarformat/calendarformatcubit.dart';
import 'package:homeworkbloc/modelview/nightswitcher/nightswitchercubit.dart';
import 'package:homeworkbloc/modelview/discipline/disciplinesbloc.dart';
import 'package:homeworkbloc/modelview/pagemanager/pagemanager.dart';
import 'package:homeworkbloc/modelview/edt/EdtBloc.dart';
import 'package:homeworkbloc/modelview/discipline/discipline.dart';

class HomeworkPage extends StatelessWidget {
  const HomeworkPage({super.key});

  @override
  Widget build(context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<NightSwitcherCubit>(context)
        ),
        BlocProvider<DisciplineBloc>(
          create: (_) => DisciplineBloc(),
        ),
        BlocProvider<PageManagerCubit>(
          create: (_) => PageManagerCubit(),
        ),
        BlocProvider<EdtBLoc>(
          create: (_) => EdtBLoc(),
        ),
        BlocProvider<HomeworkBloc>(
          create: (_) => HomeworkBloc(discipline: Discipline.empty()),
        ),
        BlocProvider(
          create: (_) => CalendarFormatCubit(),
        )
      ],
      child: MainView(),
    );
  }
}