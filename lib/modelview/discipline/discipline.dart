
class Discipline {
  int? id;
  String name;
  String semester;

  Discipline({this.id, required this.name, required this.semester});

  Discipline.fromBdd({required Map<String, Object?> map})
    : id = map["iddiscipline"] as int,
      name = map["name"] as String,
      semester = map["semester"] as String;

  Discipline.empty()
    : id = -1,
      name = "",
      semester = "S1";
}