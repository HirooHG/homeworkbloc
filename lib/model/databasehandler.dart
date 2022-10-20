import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {

  final dbname = 'iut.db';

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, dbname),
      onCreate: (database, version) async {
        await database.execute(
          "create table discipline(iddiscipline integer primary key autoincrement, name text not null, semester char(2) not null);"
        );
        await database.execute(
            "create table homework(idhomework integer primary key autoincrement, note text not null, day text not null, week numeric(2) not null);"
        );
        await database.execute(
            "create table notediscipline("
            "idhomework integer not null, "
            "iddiscipline integer not null, "
            "foreign key (idhomework) references homework(idhomework),"
            "foreign key (iddiscipline) references discipline(iddiscipline));"
        );
      },
      version: 1,
    );
  }
  Future<void> execQuery(String sql) async  {
    var db = await initializeDB();
    db.execute(sql);
  }
  Future<List<Map<String, Object?>>> rawQuery(String sql) async {
    var db = await initializeDB();
    return db.rawQuery(sql);
  }
}