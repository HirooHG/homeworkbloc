
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkbloc/modelview/discipline/discipline.dart';
import 'package:homeworkbloc/modelview/nightswitchercubit.dart';
import 'package:homeworkbloc/modelview/edt/edtdiscipline.dart';
import 'package:homeworkbloc/modelview/edt/EdtBloc.dart';
import 'package:intl/intl.dart';

class EdtView extends StatelessWidget {
  EdtView({super.key});

  late double width;
  late double height;
  late String today;

  // (height * 0.764) / dtHour,

  @override
  Widget build(context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
      builder: (context, nightSwitcherState) {
        return BlocBuilder<EdtBLoc, EdtState>(
          builder: (context, edtState) {
            today = DateFormat('EEEE').format(edtState.today);
            List<EdtDiscipline> disciplines = edtState.currentEdtDiscipline;
            disciplines.sort((EdtDiscipline a, EdtDiscipline b) {
              if(a.dateStart.hour > b.dateStart.hour) return 1;
              if(a.dateStart.hour < b.dateStart.hour) return -1;

              return 0;
            });
            return Center(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.06,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            BlocProvider.of<EdtBLoc>(context).add(ChangeDay(sens: false));
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Container (
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: nightSwitcherState.container,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: DropdownButton<String>(
                            dropdownColor: nightSwitcherState.container,
                            style: TextStyle(
                              color: nightSwitcherState.textInContainer,
                              fontWeight: FontWeight.bold
                            ),
                            borderRadius: BorderRadius.circular(8),
                            icon: Container(),
                            underline: Container(),
                            value: today,
                            items: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"].map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              );
                            }).toList(),
                            onChanged: (value) {
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            BlocProvider.of<EdtBLoc>(context).add(ChangeDay(sens: true));
                          },
                          icon: const Icon(Icons.arrow_forward),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.764,
                    width: width,
                    child: Stack(
                      children: disciplines.map((e) {
                        var location = e.location;
                        var summary = e.summary;
                        var dt = e.dt;

                        return Positioned(
                          top: (((height * 0.764) / 10) * (e.dateStart.hour - 8)),
                          width: width,
                          child: Container(
                            color: nightSwitcherState.container,
                            padding: const EdgeInsets.all(5),
                            height: ((height * 0.764) / 10) * dt,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "${e.dateStart.hour}:${e.dateStart.minute}",
                                    style: TextStyle(
                                      color: nightSwitcherState.textInContainer,
                                      fontSize: 9
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: width * 0.1),
                                      child: Text(
                                        summary,
                                        style: TextStyle(
                                          color: nightSwitcherState.textInContainer
                                        ),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                      )
                                    ),
                                    Expanded(
                                      child: Text(
                                        location,
                                        style: TextStyle(
                                          color: nightSwitcherState.textInContainer
                                        ),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                      ),
                                    )
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "${e.dateEnd.hour}:${e.dateEnd.minute}",
                                    style: TextStyle(
                                      color: nightSwitcherState.textInContainer,
                                      fontSize: 9
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        );
                      }).toList(),
                    )
                  )
                ],
              ),
            );
          }
        );
      },
    );
  }
}