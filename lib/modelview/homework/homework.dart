
class Homework {
  int? id;
  String note;
  String day;
  int week;
  int iddiscipline;

  Homework({this.id, required this.note, required this.day, required this.week, required this.iddiscipline});

  Homework.empty() :
      id = -1,
      note = "",
      week = 35,
      day = "Monday",
      iddiscipline = -1;

  Homework.fromBdd({required Map<String, Object?> map}) :
      id = map["idhomework"] as int,
      note = map["note"] as String,
      week = map["week"] as int,
      day = map["day"] as String,
      iddiscipline = map["iddiscipline"] as int;
}