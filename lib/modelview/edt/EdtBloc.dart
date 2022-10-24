import 'dart:io';

import 'package:dio/dio.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:bloc/bloc.dart';

import 'edtdiscipline.dart';

abstract class EdtEvent {

}

abstract class EdtState {
  final List<EdtDiscipline> edtDisciplines;

  const EdtState({required this.edtDisciplines});
}
class InitState extends EdtState {
  const InitState({required super.edtDisciplines});

  init() async {
    var dio = Dio();
    Response res;

    res = await dio.post(
        "https://ade6-usmb-ro.grenet.fr/jsp/custom/modules/plannings/direct_cal.jsp",
        queryParameters: {
          "data": "1b9e1ac2a1720dfd6bd1d42ad86c77f9c55ef35a53135e0070a97be8b09957efa9a0e9cb08b4730b",
          "resources": 2663,
          "projectId": 4,
          "calType": "ical",
          "lastDate": "2040-08-14"
        }
    ).timeout(const Duration(seconds: 5), onTimeout: () async {
      var response = Response(requestOptions: RequestOptions(path: ''));
      response.data = await File("/data/user/0/fr.HirooDebug.homeworkbloc/files/edt.ics").readAsString();
      return response;
    });

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

      var description = a["description"] as String;
      var summary = a["summary"] as String;
      var location = a["location"] as String;

      EdtDiscipline discipline = EdtDiscipline(
        summary: summary,
        location: location,
        description: description,
        dateEnd: parseDt(year: yearEnd, month: monthEnd, day: dayEnd),
        dateStart: parseDt(year: yearStart, month: monthStart, day: dayStart)
      );
      edtDisciplines.add(discipline);
    }
  }
  DateTime parseDt({required String year, required String month, required String day}) {
    int yearInt = int.parse(year);
    int monthInt = int.parse(month);
    int dayInt = int.parse(day);
    DateTime res = DateTime(yearInt, monthInt, dayInt);
    return res;
  }
}

class EdtBLoc extends Bloc<EdtEvent, EdtState> {
  EdtBLoc() : super() {
    on<EdtEvent>(onEdtEvent);
  }

  onEdtEvent(EdtEvent event, Emitter<EdtState> emit) {

  }
}