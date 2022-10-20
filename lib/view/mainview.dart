
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
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: width * 0.2,
                        margin: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(50),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: TextButton(
                          onPressed: () {

                          },
                          child: const Text(
                            "Add",
                            style: TextStyle(
                              color: Color(0xFFE4CFA9),
                              fontWeight: FontWeight.bold
                            )
                          )
                        )
                      )
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
        return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
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
                    width: width * .2,
                    child: Icon(Icons.numbers, color: nightSwitcherState.textInContainer),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Math",
                        style: TextStyle(
                          fontSize: 18,
                          color: nightSwitcherState.textInContainer
                        )
                      ),
                    )
                  ),
                  IconButton(
                    onPressed: () {
                      bottomSheetAdd(context: context);
                    },
                    icon: Icon(Icons.mode, color: nightSwitcherState.textInContainer),
                  ),
                  IconButton(
                    onPressed: () {
                      //
                    },
                    icon: Icon(Icons.arrow_forward, color: nightSwitcherState.textInContainer),
                  )
                ],
              )
            );
          },
        );
      },
    );
  }
}