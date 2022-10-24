
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'mainview.dart';
import 'package:homeworkbloc/modelview/nightswitchercubit.dart';
import 'package:homeworkbloc/modelview/discipline/disciplinesbloc.dart';
import 'package:homeworkbloc/modelview/pagemanager.dart';

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
        )
      ],
      child: MainView(),
    );
  }
}