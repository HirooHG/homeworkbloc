
import 'package:bloc/bloc.dart';

import 'homework.dart';
import 'package:homeworkbloc/model/databasehandler.dart';
import '../discipline/discipline.dart';

class HomeworkEvent {
  const HomeworkEvent();
}
class InitHomeworkEvent extends HomeworkEvent {

}
class RemoveHomeworkEvent extends HomeworkEvent {
  const RemoveHomeworkEvent({required this.homework});

  final Homework homework;
}
class AddHomeworkEvent extends HomeworkEvent {
  const AddHomeworkEvent({required this.homework});

  final Homework homework;
}
class ModifyHomeworkEvent extends HomeworkEvent {
  const ModifyHomeworkEvent({required this.homework});

  final Homework homework;
}
class ChangeDisciplineEvent extends HomeworkEvent {
  const ChangeDisciplineEvent({required this.discipline});

  final Discipline discipline;
}

class HomeworkState {
  List<Homework> homeworks;
  final List<Homework> allHomeworks;
  Discipline discipline;
  final handler = DatabaseHandler();

  HomeworkState({required this.homeworks, required this.discipline, required this.allHomeworks});
}
class InitHomeworkState extends HomeworkState {
  InitHomeworkState({required super.homeworks, required super.discipline, required super.allHomeworks});

  init() async {
    var list = await handler.rawQuery("select * from homework;");

    for(var i in list) {
      Homework homework = Homework.fromBdd(map: i);
      if(!homeworks.any((element) => element.id == homework.id)) {
        if(homework.iddiscipline == discipline.id) homeworks.add(homework);
        allHomeworks.add(homework);
      }
    }
  }
}
class RemovedHomeworkState extends HomeworkState {
  RemovedHomeworkState({required super.homeworks, required super.discipline, required super.allHomeworks});

  remove(Homework homework) async {
    await handler.execQuery("delete from homework where idhomework = ${homework.id}");
    homeworks.remove(homework);
    allHomeworks.remove(homework);
  }
}
class AddedHomeworkState extends HomeworkState {
  AddedHomeworkState({required super.homeworks, required super.allHomeworks, required super.discipline});

  add(Homework homework) async {
    homeworks.add(homework);
    allHomeworks.add(homework);

    await handler.execQuery(
        "insert into homework (note, day, week, iddiscipline) "
          "values ('${homework.note}', '${homework.day}', ${homework.week}, ${discipline.id});"
    );
    homework.id = (await handler.rawQuery("select idhomework from homework "
        " where note = '${homework.note}'"
        " and day ='${homework.day}'"
        " and week = ${homework.week};"))[0]["idhomework"] as int;
  }
}
class ModifiedHomeworkState extends HomeworkState {
  ModifiedHomeworkState({required super.homeworks, required super.discipline, required super.allHomeworks});

  modify(Homework homework) async {
    await handler.execQuery(
        "update homework set note = '${homework.note}',"
          " day = '${homework.day}' where idhomework = ${homework.id};"
    );
  }
}

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  HomeworkBloc({required Discipline discipline}) : super(InitHomeworkState(homeworks: [ ], allHomeworks: [], discipline: discipline)) {
    on<HomeworkEvent>(onEventDiscipline);
  }

  onEventDiscipline(HomeworkEvent event, Emitter<HomeworkState> emit) async {
    switch(event.runtimeType) {
      case InitHomeworkEvent:
        InitHomeworkState nextState = InitHomeworkState(homeworks: state.homeworks, allHomeworks: state.allHomeworks, discipline: state.discipline);
        await nextState.init();
        emit(nextState);
        break;
      case RemoveHomeworkEvent:
        RemovedHomeworkState nextState = RemovedHomeworkState(homeworks: state.homeworks, allHomeworks: state.allHomeworks, discipline: state.discipline);
        nextState.remove((event as RemoveHomeworkEvent).homework);
        emit(nextState);
        break;
      case AddHomeworkEvent:
        AddedHomeworkState nextState = AddedHomeworkState(homeworks: state.homeworks, allHomeworks: state.allHomeworks, discipline: state.discipline);
        nextState.add((event as AddHomeworkEvent).homework);
        emit(nextState);
        break;
      case ModifyHomeworkEvent:
        ModifiedHomeworkState nextState = ModifiedHomeworkState(homeworks: state.homeworks, allHomeworks: state.allHomeworks, discipline: state.discipline);
        nextState.modify((event as ModifyHomeworkEvent).homework);
        emit(nextState);
        break;
      case ChangeDisciplineEvent:

        break;
    }
  }
}
