
import 'package:flutter/material.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkbloc/modelview/nightswitchercubit.dart';
import 'package:homeworkbloc/modelview/discipline/discipline.dart';
import 'package:homeworkbloc/modelview/discipline/disciplinesbloc.dart';

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
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: DisciplinesList(),
                  ),
                ),
                Container(
                  width: width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: nightSwitcherState.textDefault, width: 2.0)
                  ),
                  child: AddForm(),
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
                color: state.textDefault
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
   AddForm({super.key});

  final disciplineController = TextEditingController();
  final disciplineFocusNode = FocusNode();
  final semesterController = TextEditingController();
  final semesterFocusNode = FocusNode();

  final regexSemester = RegExp(r"^S[1-6]$");

  bottomSheetAdd({required BuildContext context}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Scaffold.of(context).showBottomSheet<void>(
      elevation: 10.0,
      backgroundColor: Colors.transparent,
          (_) {
        return BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
          builder: (context, state) {
            return Container(
              height: height * 0.6,
              decoration: BoxDecoration(
                color: state.container,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Adding Disciplines",
                          style: TextStyle(
                            color: state.textInContainer,
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      )
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.symmetric(horizontal: BorderSide(color: state.textInContainer))
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.only(top: 10),
                      height: height  * 0.1,
                      child: TextField(
                        focusNode: disciplineFocusNode,
                        controller: disciplineController,
                        onTapOutside: (event) => disciplineFocusNode.unfocus(),
                        cursorColor: state.textInContainer,
                        style: TextStyle(
                          color: state.textInContainer,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                          label: Text(
                            "Discipline",
                            style: TextStyle(
                              color: state.textInContainer
                            )
                          )
                        ),
                      )
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.symmetric(horizontal: BorderSide(color: state.textInContainer))
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.only(top: 10),
                      height: height  * 0.1,
                      child: TextField(
                        focusNode: semesterFocusNode,
                        controller: semesterController,
                        onTapOutside: (event) => semesterFocusNode.unfocus(),
                        cursorColor: state.textInContainer,
                        style: TextStyle(
                          color: state.textInContainer,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                          label: Text(
                            "Semester",
                            style: TextStyle(
                              color: state.textInContainer
                            )
                          )
                        ),
                      )
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: width * 0.2,
                        decoration: BoxDecoration(
                          color: state.containerText,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: TextButton(
                          onPressed: () {
                            String name = disciplineController.text.replaceAll("'", "''");
                            String semester = semesterController.text.replaceAll("'", "''");

                            if(name.isNotEmpty && regexSemester.hasMatch(semester)) {
                              Discipline newDiscipline = Discipline(name: name, semester: semester);
                              BlocProvider.of<DisciplineBloc>(context).add(AddDisciplineEvent(discipline: newDiscipline));
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(
                              color: state.textDefault,
                              fontWeight: FontWeight.bold
                            )
                          )
                        )
                      )
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(context) {
    return BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
      builder: (context, state) {
       return TextButton(
         onPressed: () {
           bottomSheetAdd(context: context);
         },
         child: Row(
           children: [
              Icon(Icons.add, color: state.textColor, size: 25),
              Text("Add Discipline", style: TextStyle(color: state.textDefault, fontSize: 20))
            ],
          ),
        );
      },
    );
  }
}
class DisciplinesList extends StatelessWidget {
  DisciplinesList({super.key});

  final disciplineController = TextEditingController();
  final disciplineFocusNode = FocusNode();
  final semesterController = TextEditingController();
  final semesterFocusNode = FocusNode();

  bottomSheetModify({required BuildContext context, required Discipline discipline}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    disciplineController.text = discipline.name;
    semesterController.text = discipline.semester;

    Scaffold.of(context).showBottomSheet<void>(
      elevation: 10.0,
      backgroundColor: Colors.transparent,
          (_) {
        return BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
          builder: (context, state) {
            return Container(
              height: height * 0.6,
              decoration: BoxDecoration(
                color: state.container,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Modifying Disciplines",
                          style: TextStyle(
                            color: state.textInContainer,
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      )
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.symmetric(horizontal: BorderSide(color: state.textInContainer))
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.only(top: 10),
                      height: height  * 0.1,
                      child: TextField(
                        focusNode: disciplineFocusNode,
                        controller: disciplineController,
                        onTapOutside: (event) => disciplineFocusNode.unfocus(),
                        cursorColor: state.textInContainer,
                        style: TextStyle(
                          color: state.textInContainer,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                          label: Text(
                            "Discipline",
                            style: TextStyle(
                              color: state.textInContainer
                            )
                          )
                        ),
                      )
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.symmetric(horizontal: BorderSide(color: state.textInContainer))
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.only(top: 10),
                      height: height  * 0.1,
                      child: TextField(
                        focusNode: semesterFocusNode,
                        controller: semesterController,
                        onTapOutside: (event) => semesterFocusNode.unfocus(),
                        cursorColor: state.textInContainer,
                        style: TextStyle(
                          color: state.textInContainer,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                          label: Text(
                            "Semester",
                            style: TextStyle(
                              color: state.textInContainer
                            )
                          )
                        ),
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: width * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: TextButton(
                            onPressed: () {
                              BlocProvider.of<DisciplineBloc>(context).add(RemoveDisciplineEvent(discipline: discipline));
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Remove",
                              style: TextStyle(
                                color: state.textDefault,
                                fontWeight: FontWeight.bold
                              )
                            )
                          )
                        ),
                        Container(
                          width: width * 0.2,
                          decoration: BoxDecoration(
                            color: state.containerText,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Modify",
                              style: TextStyle(
                                color: state.textDefault,
                                fontWeight: FontWeight.bold
                              )
                            )
                          )
                        )
                      ]
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
      builder: (context, nightSwitcherState) {
        BlocProvider.of<DisciplineBloc>(context).add(InitDisciplinesEvent());
        return BlocBuilder<DisciplineBloc, DisciplineState>(
          builder: (context, disciplinesState) {
            List<Discipline> disciplines = disciplinesState.disciplines;
            return ListView.builder(
              itemCount: disciplines.length,
              itemBuilder: (context, index) {
                Discipline discipline = disciplines[index];
                return Container(
                  height: height * .1,
                  margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                  decoration: BoxDecoration(
                    color: nightSwitcherState.container,
                    borderRadius: BorderRadius.circular(40)
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.2,
                        child: IconButton(
                          onPressed: () {
                            bottomSheetModify(context: context, discipline: discipline);
                          },
                          icon: Icon(Icons.mode, color: nightSwitcherState.textInContainer),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            discipline.name,
                            style: TextStyle(
                              fontSize: 18,
                              color: nightSwitcherState.textInContainer
                            )
                          ),
                        )
                      ),
                      SizedBox(
                        width: width * 0.2,
                        child: IconButton(
                          onPressed: () {
                          },
                          icon: Icon(Icons.arrow_forward, color: nightSwitcherState.textInContainer),
                        ),
                      ),
                    ],
                  )
                );
              },
            );
          },
        );
      },
    );
  }
}