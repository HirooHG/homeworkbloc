
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkbloc/modelview/homework/homework.dart';
import 'package:homeworkbloc/modelview/homework/homeworksbloc.dart';
import 'package:homeworkbloc/modelview/nightswitchercubit.dart';
import 'package:homeworkbloc/modelview/discipline/discipline.dart';

class HomeworkView extends StatelessWidget {
  const HomeworkView({super.key, required this.discipline});

  final Discipline discipline;

  @override
  Widget build(context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    BlocProvider.of<HomeworkBloc>(context).add(InitHomeworkEvent());

    return BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
      builder: (context, nightSwitcherState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              discipline.name
            ),
          ),
          body: Container(
            padding: const EdgeInsets.only(bottom: 20),
            width: width,
            height: height,
            child: Column(
              children: [
                SizedBox(
                  height: height * .2,
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: width * 0.1, left: width * 0.1),
                          child: Text(
                            discipline.name,
                            style: TextStyle(
                              color: nightSwitcherState.textDefault,
                              fontSize: 40,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          discipline.semester,
                          style: TextStyle(
                            color: nightSwitcherState.textDefault,
                            fontSize: 25
                          )
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Homeworks(discipline: discipline),
                ),
                Container(
                  width: width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: nightSwitcherState.textDefault, width: 2.0)
                  ),
                  child: AddForm(discipline: discipline)
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
class Homeworks extends StatelessWidget {
  Homeworks({super.key, required this.discipline});

  final noteController = TextEditingController();
  final noteFocusNode = FocusNode();
  final weekController = TextEditingController();
  final weekFocusNode = FocusNode();

  final Discipline discipline;

  String valueDDDay = "Monday";

  bottomSheetModify({required BuildContext context, required Homework homework}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Scaffold.of(context).showBottomSheet<void>(
      elevation: 10.0,
      backgroundColor: Colors.transparent,
          (_) {
        return BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
          builder: (context, state) {
            noteController.text = homework.note;
            weekController.text = homework.week.toString();
            valueDDDay = homework.day;
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
                          "Adding Homeworks",
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
                          focusNode: noteFocusNode,
                          controller: noteController,
                          onTapOutside: (event) => noteFocusNode.unfocus(),
                          cursorColor: state.textInContainer,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(
                            color: state.textInContainer,
                          ),
                          decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                              enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                              label: Text(
                                  "Note",
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
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.only(top: 10),
                            height: height  * 0.1,
                            width: width * 0.2,
                            child: TextField(
                              focusNode: weekFocusNode,
                              controller: weekController,
                              onTapOutside: (event) => weekFocusNode.unfocus(),
                              cursorColor: state.textInContainer,
                              style: TextStyle(
                                color: state.textInContainer,
                              ),
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: state.textInContainer)),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: state.textInContainer)),
                                  label: Text(
                                      "Week",
                                      style: TextStyle(
                                          color: state.textInContainer
                                      )
                                  )
                              ),
                            )
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                                color: state.containerText,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            width: width * 0.3,
                            child: DropdownButton<String>(
                                value: valueDDDay,
                                dropdownColor: state.containerText,
                                style: TextStyle(
                                    color: state.textDefault,
                                    fontWeight: FontWeight.bold
                                ),
                                borderRadius: BorderRadius.circular(8),
                                icon: Container(),
                                underline: Container(),
                                onChanged: (value) {
                                  valueDDDay = value!;
                                },
                                items: ["Monday", "Tuesday", "Wednesday", "Thurday", "Friday"]
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList()
                            )
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: width * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: BlocBuilder<HomeworkBloc, HomeworkState>(
                            builder: (context, homeworkState) {
                              return TextButton(
                                onPressed: () {
                                  BlocProvider.of<HomeworkBloc>(context).add(RemoveHomeworkEvent(homework: homework));
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Remove",
                                  style: TextStyle(
                                    color: state.textDefault,
                                    fontWeight: FontWeight.bold
                                  )
                                )
                              );
                            },
                          )
                        ),
                        Container(
                          width: width * 0.2,
                          decoration: BoxDecoration(
                            color: state.containerText,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: BlocBuilder<HomeworkBloc, HomeworkState>(
                            builder: (context, homeworkState) {
                              return TextButton(
                                onPressed: () {
                                  String note = noteController.text.replaceAll("'", "''");
                                  int? week = int.tryParse(weekController.text);

                                  if(note.isNotEmpty && week != null && week <= 52) {
                                    homework.note = note;
                                    homework.day = valueDDDay;
                                    homework.week = week;
                                    BlocProvider.of<HomeworkBloc>(context).add(ModifyHomeworkEvent(homework: homework));
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  "Modify",
                                  style: TextStyle(
                                    color: state.textDefault,
                                    fontWeight: FontWeight.bold
                                  )
                                )
                              );
                            },
                          )
                        ),

                      ],
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

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
      builder: (context, nightSwitcherState) {
        return BlocBuilder<HomeworkBloc, HomeworkState>(
          builder: (context, homeworkState) {
            List<Homework> list = homeworkState.homeworks;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                Homework currentHomework = list[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: height * 0.03),
                  padding: const EdgeInsets.all(15),
                  height: height * 0.25,
                  decoration: BoxDecoration(
                    color: nightSwitcherState.container,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentHomework.note,
                        style: TextStyle(
                          color: nightSwitcherState.textInContainer,
                          fontSize: 17
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width * 0.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  currentHomework.day,
                                  style: TextStyle(
                                    color: nightSwitcherState.textInContainer,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  "Week ${currentHomework.week}",
                                  style: TextStyle(
                                    color: nightSwitcherState.textInContainer,
                                    fontSize: 17
                                  ),
                                )
                              ],
                            )
                          ),
                          IconButton(
                            onPressed: () {
                              bottomSheetModify(context: context, homework: currentHomework);
                            },
                            icon: Icon(Icons.mode, color: nightSwitcherState.textInContainer),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
class AddForm extends StatelessWidget {
  AddForm({super.key, required this.discipline});

  final noteController = TextEditingController();
  final noteFocusNode = FocusNode();
  final weekController = TextEditingController();
  final weekFocusNode = FocusNode();

  final Discipline discipline;

  String valueDDDay = "Monday";

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
                          "Adding Homeworks",
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
                        focusNode: noteFocusNode,
                        controller: noteController,
                        onTapOutside: (event) => noteFocusNode.unfocus(),
                        cursorColor: state.textInContainer,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(
                          color: state.textInContainer,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                          label: Text(
                            "Note",
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
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.only(top: 10),
                          height: height  * 0.1,
                          width: width * 0.2,
                          child: TextField(
                            focusNode: weekFocusNode,
                            controller: weekController,
                            onTapOutside: (event) => weekFocusNode.unfocus(),
                            cursorColor: state.textInContainer,
                            style: TextStyle(
                              color: state.textInContainer,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: state.textInContainer)),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: state.textInContainer)),
                              label: Text(
                                "Week",
                                style: TextStyle(
                                  color: state.textInContainer
                                )
                              )
                            ),
                          )
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: state.containerText,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          width: width * 0.3,
                          child: DropdownButton<String>(
                            value: valueDDDay,
                            dropdownColor: state.containerText,
                            style: TextStyle(
                              color: state.textDefault,
                              fontWeight: FontWeight.bold
                            ),
                            borderRadius: BorderRadius.circular(8),
                            icon: Container(),
                            underline: Container(),
                            onChanged: (value) {
                              valueDDDay = value!;
                            },
                            items: ["Monday", "Tuesday", "Wednesday", "Thurday", "Friday"]
                              .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()
                          )
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: width * 0.2,
                        decoration: BoxDecoration(
                          color: state.containerText,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: BlocBuilder<HomeworkBloc, HomeworkState>(
                          builder: (context, homeworkState) {
                            return TextButton(
                              onPressed: () {
                                String note = noteController.text.replaceAll("'", "''");
                                int? week = int.tryParse(weekController.text);

                                if(note.isNotEmpty && week != null) {
                                  Homework homework = Homework(note: note, day: valueDDDay, week: week, iddiscipline: discipline.id!);
                                  BlocProvider.of<HomeworkBloc>(context).add(AddHomeworkEvent(homework: homework));
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
                            );
                          },
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
              Icon(Icons.add, color: state.textDefault, size: 25),
              Text("Add Homework", style: TextStyle(color: state.textDefault, fontSize: 20))
            ],
          ),
        );
      },
    );
  }
}
