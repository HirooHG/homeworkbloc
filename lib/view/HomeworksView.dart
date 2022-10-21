
import 'package:flutter/material.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkbloc/modelview/nightswitchercubit.dart';
import 'package:homeworkbloc/modelview/discipline/discipline.dart';

class HomeworkView extends StatelessWidget {
  const HomeworkView({super.key, required this.discipline});

  final Discipline discipline;

  @override
  Widget build(context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                  child: Container(),
                ),
                Container(
                  width: width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: nightSwitcherState.textDefault, width: 2.0)
                  ),
                  child: AddForm()
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
  const Homeworks({super.key});

  @override
  Widget build(context) {
    return BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
      builder: (context, nightSwitcherState) {
        return BlocBuilder(
          builder: (context, homeworkState) {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Container();
              },
            );
          },
        );
      },
    );
  }
}
class AddForm extends StatelessWidget {
  AddForm({super.key});

  final noteController = TextEditingController();
  final noteFocusNode = FocusNode();
  final weekController = TextEditingController();
  final weekFocusNode = FocusNode();

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
                        onSubmitted: (value) {
                          weekFocusNode.requestFocus();
                        },
                      )
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.only(top: 10),
                          height: height  * 0.1,
                          width: width * 0.3,
                          child: TextField(
                            focusNode: weekFocusNode,
                            controller: weekController,
                            onTapOutside: (event) => weekFocusNode.unfocus(),
                            cursorColor: state.textInContainer,
                            style: TextStyle(
                              color: state.textInContainer,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: state.textDefault)),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: state.textDefault)),
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
                            color: state.container,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          width: width * 0.3,
                          child: DropdownButton<String>(
                            value: valueDDDay,
                            dropdownColor: state.container,
                            style: TextStyle(
                              color: state.textInContainer,
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
                        child: BlocBuilder(
                          builder: (context, disciplineState) {
                            return TextButton(
                              onPressed: () {
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
