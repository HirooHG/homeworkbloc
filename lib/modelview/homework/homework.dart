
class Homework {
  int? id;
  String note;
  String day;
  int week;

  Homework({this.id, required this.note, required this.day, required this.week});

  Homework.empty() :
      id = -1,
      note = "",
      week = 35,
      day = "Monday";

  Homework.fromBdd({required Map<String, Object?> map}) :
      id = map["idhomework"] as int,
      note = map["note"] as String,
      week = map["week"] as int,
      day = map["day"] as String;
}