
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:homeworkbloc/modelview/nightswitcher/nightswitchercubit.dart';
import 'package:homeworkbloc/modelview/edt/edtdiscipline.dart';
import 'package:homeworkbloc/modelview/edt/EdtBloc.dart';
import 'package:homeworkbloc/modelview/calendarformat/calendarformatcubit.dart';

const discColors = {
  "R3.01": Color(0xffffb31c),
  "R3.02": Color(0xffffbe6e),
  "R3.03": Color(0xffa1ff3d),
  "R3.04": Color(0xffcdff42),
  "R3.05": Color(0xffff9d00),
  "R3.06": Color(0xfffff833),
  "R3.07": Color(0xffa25bd9),
  "R3.08": Color(0xff8cffa3),
  "R3.09": Color(0xffdfff6b),
  "R3.10": Color(0xffb7a1ff),
  "R3.11": Color(0xffbda1ff),
  "R3.12": Color(0xfffa70ff),
  "R3.13": Color(0xff974fe0),
  "R3.14": Color(0xff00ff00),
  "S3.01": Color(0xffcccccc),
  "PPP-S": Color(0xffccffcc),
};

class EdtView extends StatelessWidget {
  EdtView({super.key});

  late double width;
  late double height;
  late String today;

  RegExp discReg = RegExp(r"^([RS][1-3]).([01][1-9])$");

  calendarBottom({required BuildContext context, required DateTime todayD}){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<EdtBLoc>(context),
            ),
            BlocProvider.value(
              value: BlocProvider.of<CalendarFormatCubit>(context),
            )
          ],
          child: BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
            builder: (context, nightState) {
              return BlocBuilder<EdtBLoc, EdtState>(
                builder: (context, edtState) {
                  return BlocBuilder<CalendarFormatCubit, CalendarFormat>(
                    builder: (context, calendarFormatState) {
                      return Container(
                        color: nightState.textInContainer,
                        height: height * 0.55,
                        child: TableCalendar(
                          currentDay: edtState.today,
                          calendarFormat: calendarFormatState,
                          focusedDay: edtState.today,
                          firstDay: DateTime(2021, DateTime.september),
                          lastDay: DateTime(2024, DateTime.july),
                          onFormatChanged: (format) {
                            BlocProvider.of<CalendarFormatCubit>(context).changeFormat(format);
                          },
                          onDaySelected: (day, _) {
                            BlocProvider.of<EdtBLoc>(context).add(ChangeDayCalendar(day: day));
                            Navigator.pop(context);
                          },
                        )
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      }
    );
  }

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
                            BlocProvider.of<EdtBLoc>(context).add(const ChangeDay(sens: false));
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Container (
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: nightSwitcherState.container,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: TextButton(
                              onPressed: () {
                                calendarBottom(context: context, todayD: edtState.today);
                              },
                              child: Text(
                                today,
                                style: TextStyle(
                                  color: nightSwitcherState.textInContainer,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                        ),
                        IconButton(
                          onPressed: () {
                            BlocProvider.of<EdtBLoc>(context).add(const ChangeDay(sens: true));
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
                        var discR = summary.substring(0, 5);

                        var listDesc = e.description.split(r"\n");
                        var name = listDesc[0];
                        var group = listDesc[2];
                        var teacher = listDesc[3];

                        var contColor = discColors[discR];
                        contColor ??= const Color(0xffff6666);
                        print(contColor);
                        print(discR);

                        var dt = e.dt;

                        return Positioned(
                          top: (((height * 0.764) / 10) * (e.dateStart.hour - 8)),
                          width: width,
                          child: Container(
                            color: contColor,
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
                                      fontSize: 6
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        teacher,
                                        style: TextStyle(
                                          color: nightSwitcherState.textInContainer,
                                          fontSize: 8
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: width * 0.1),
                                            child: Text(
                                              summary,
                                              style: TextStyle(
                                                color: nightSwitcherState.textInContainer,
                                                fontSize: 14
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
                                                color: nightSwitcherState.textInContainer,
                                                fontSize: 14
                                              ),
                                              softWrap: false,
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        "$name - $group",
                                        style: TextStyle(
                                          color: nightSwitcherState.textInContainer,
                                          fontSize: 8
                                        )
                                      )
                                    ],
                                  )
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "${e.dateEnd.hour}:${e.dateEnd.minute}",
                                    style: TextStyle(
                                      color: nightSwitcherState.textInContainer,
                                      fontSize: 6
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