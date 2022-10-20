
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:homeworkbloc/modelview/nightswitchercubit.dart';
import 'mainview.dart';
import 'package:homeworkbloc/modelview/discipline/disciplinesbloc.dart';

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
        )
      ],
      child: const MainView(),
    );
  }
}