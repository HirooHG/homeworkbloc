import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:bloc/bloc.dart';

import 'edtdiscipline.dart';

abstract class EdtEvent {

}
class InitEvent extends EdtEvent {

}
class ChangeDay extends EdtEvent {
  ChangeDay({required this.sens});

  final bool sens;
}

abstract class EdtState {
  List<EdtDiscipline> allEdtDisciplines;
  List<EdtDiscipline> currentEdtDiscipline;
  DateTime today;

  EdtState({required this.allEdtDisciplines, required this.currentEdtDiscipline, required this.today});
}
class InitState extends EdtState {
  InitState({required super.allEdtDisciplines, required super.currentEdtDiscipline, required super.today});

  init() async {
    var dio = Dio();
    var res = Response(requestOptions: RequestOptions(path: ''));

    res = await dio.post(
      "https://ade-usmb-ro.grenet.fr/jsp/custom/modules/plannings/direct_cal.jsp",
      queryParameters: {
       "data": "b5cfb898a9c27be94975c12c6eb30e9233bdfae22c1b52e2cd88eb944acf5364c69e3e5921f4a6ebe36e93ea9658a08f,1",
       "resources": 2663,
       "projectId": 4,
       "calType": "ical",
       "lastDate": "2042-08-14"
      }
    ).timeout(const Duration(seconds: 5), onTimeout: () async {
      if(kDebugMode) print("timed out");
      res.data = await File("/data/user/0/fr.HirooDebug.homeworkbloc/files/edt.ics").readAsString();
      return res;
    })
     .onError((error, stackTrace) async {
      if(kDebugMode) print(error);
      res.data = await File("/data/user/0/fr.HirooDebug.homeworkbloc/files/edt.ics").readAsString();
      return res;
    });

    await File("/data/user/0/fr.HirooDebug.homeworkbloc/files/edt.ics").writeAsString(res.data);

    final cal = ICalendar.fromString(res.data);

    for(var a in cal.data) {
      var dtstart = (a["dtstart"] as IcsDateTime).dt;
      var dtend = (a["dtend"] as IcsDateTime).dt;

      var yearStart = dtstart.substring(0, 4);
      var yearEnd = dtend.substring(0, 4);
      var monthStart = dtstart.substring(4, 6);
      var monthEnd = dtend.substring(4, 6);
      var dayStart = dtstart.substring(6, 8);
      var dayEnd = dtend.substring(6, 8);
      var hourStart = dtstart.substring(9, 11);
      var hourEnd = dtend.substring(9, 11);
      var minuteStart = dtstart.substring(11, 13);
      var minuteEnd = dtend.substring(11, 13);

      var description = a["description"] as String;
      var summary = a["summary"] as String;
      var location = a["location"] as String;

      var dateEnd = parseDt(year: yearEnd, month: monthEnd, day: dayEnd, hour: hourEnd, minute: minuteEnd);
      var dateStart = parseDt(year: yearStart, month: monthStart, day: dayStart, hour: hourStart, minute: minuteStart);

      EdtDiscipline discipline = EdtDiscipline(
        summary: summary,
        location: location,
        description: description,
        dateEnd: dateEnd,
        dateStart: dateStart
      );
      allEdtDisciplines.add(discipline);
      bool c = discipline.dateStart.day == today.day
              &&  discipline.dateStart.month == today.month
              && discipline.dateStart.year == today.year;
      bool b = currentEdtDiscipline.any((element) => element.dateStart == discipline.dateStart && element.dateEnd == discipline.dateEnd);

      if(c && !b) {
        currentEdtDiscipline.add(discipline);
      }
    }
  }
  DateTime parseDt({required String year, required String month, required String day, required String hour, required String minute}) {
    int yearInt = int.parse(year);
    int monthInt = int.parse(month);
    int dayInt = int.parse(day);
    int hourInt = int.parse(hour) + 1;
    int minuteInt = int.parse(minute);
    DateTime res = DateTime(yearInt, monthInt, dayInt, hourInt, minuteInt);
    return res;
  }
}
class ChangedDay extends EdtState {
  ChangedDay({required super.allEdtDisciplines, required super.currentEdtDiscipline, required super.today});

  change(bool sens) {
    if(sens) {
      today = today.add(const Duration(days: 1));
    } else {
      today = today.subtract(const Duration(days: 1));
    }
    currentEdtDiscipline.clear();
    currentEdtDiscipline = allEdtDisciplines.where((discipline) => discipline.dateStart.day == today.day
          &&  discipline.dateStart.month == today.month
          && discipline.dateStart.year == today.year).toList();
  }
}

class EdtBLoc extends Bloc<EdtEvent, EdtState> {
  EdtBLoc() : super(InitState(allEdtDisciplines: [], currentEdtDiscipline: [], today: DateTime.now())) {
    on<EdtEvent>(onEdtEvent);
  }

  onEdtEvent(EdtEvent event, Emitter<EdtState> emit) async {
    switch(event.runtimeType) {
      case InitEvent:
        InitState nextState = InitState(
          allEdtDisciplines: state.allEdtDisciplines,
          currentEdtDiscipline: state.currentEdtDiscipline,
          today: state.today
        );
        await nextState.init();
        emit(nextState);
        break;
      case ChangeDay:
        ChangedDay changedDay = ChangedDay(
          allEdtDisciplines: state.allEdtDisciplines,
          currentEdtDiscipline: state.currentEdtDiscipline,
          today: state.today
        );
        changedDay.change((event as ChangeDay).sens);
        emit(changedDay);
        break;
    }
  }
}