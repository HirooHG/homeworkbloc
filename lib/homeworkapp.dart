
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'view/homeworkpage.dart';
import 'modelview/nightswitcher/nightswitchercubit.dart';

class HomeworkApp extends StatelessWidget {
  const HomeworkApp({super.key});

  @override
  Widget build(context) {
    return BlocProvider(
      create: (_) => NightSwitcherCubit(),
      child: BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
        builder: (context, state) {
          return MaterialApp(
            home: const HomeworkPage(),
            debugShowCheckedModeBanner: false,
            themeMode: state.themeMode,
            theme: state.light,
            darkTheme: state.dark,
          );
        }
      ),
    );
  }
}