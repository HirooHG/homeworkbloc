
import 'package:flutter/material.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkbloc/modelview/nightswitchercubit.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
            width: width,
            height: height,
            padding: EdgeInsets.symmetric(vertical: height * 0.05),
            child: Column(
              children: [
                SizedBox(
                  width: width * 0.6,
                  child: SearchField(),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: const DisciplinesList(),
                  ),
                ),
                Container(
                  width: width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: nightSwitcherState.textDefault, width: 2.0)
                  ),
                  child: const AddForm(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchField extends StatelessWidget {
  SearchField({super.key});

  final searchDisciplineController = TextEditingController();

  @override
  Widget build(context) {
    return BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
      builder: (context, state) {
        return TextField(
          controller: searchDisciplineController,
          cursorColor: state.textColor,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: state.textDefault, width: 2.0)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: state.textDefault, width: 2.0)),
            label: Text(
              "Search discipline",
              style: TextStyle(
                color: state.textColor
              )
            )
          ),
          onSubmitted: (value) {
          },
        );
      },
    );
  }
}
class AddForm extends StatelessWidget {
  const AddForm({super.key});

  @override
  Widget build(context) {
    return BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
      builder: (context, state) {
       return TextButton(
         onPressed: () {
         },
         child: Row(
          children: [
            Icon(Icons.add, color: state.textColor, size: 25),
            Text("Add Discipline", style: TextStyle(color: state.textColor, fontSize: 20))
          ],
         ),
        );
      },
    );
  }
}
class DisciplinesList extends StatelessWidget {
  const DisciplinesList({super.key});

  @override
  Widget build(context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
      builder: (context, nightSwitcherState) {
        return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Container(
              width: width * .6,
              height: height * .1,
              margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
              decoration: BoxDecoration(
                color: nightSwitcherState.containerTextColor,
                borderRadius: BorderRadius.circular(40)
              ),
            );
          },
        );
      },
    );
  }
}