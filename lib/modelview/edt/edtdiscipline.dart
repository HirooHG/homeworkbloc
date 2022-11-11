
class EdtDiscipline {
  final String summary;
  final String location;
  final String description;
  final DateTime dateStart;
  final DateTime dateEnd;
  int dt = 0;

  EdtDiscipline({
    required this.summary,
    required this.location,
    required this.description,
    required this.dateEnd,
    required this.dateStart
  }) {
    dt = (dateEnd.hour - dateStart.hour);
  }

  EdtDiscipline.empty() :
      summary = "",
      location = "",
      description = "",
      dateStart = DateTime.now(),
      dateEnd = DateTime.now();
}