
import 'package:bloc/bloc.dart';
import 'discipline.dart';
import 'package:homeworkbloc/model/databasehandler.dart';

class DisciplineEvent {
  const DisciplineEvent();
}
class InitDisciplinesEvent extends DisciplineEvent {

}
class RemoveDisciplineEvent extends DisciplineEvent {
  const RemoveDisciplineEvent({required this.discipline});

  final Discipline discipline;
}
class AddDisciplineEvent extends DisciplineEvent {
  const AddDisciplineEvent({required this.discipline});

  final Discipline discipline;
}
class ModifyNoteEvent extends DisciplineEvent {
  const ModifyNoteEvent({required this.discipline});

  final Discipline discipline;
}

class DisciplineState {
  final List<Discipline> disciplines;
  final handler = DatabaseHandler();

  DisciplineState({required this.disciplines});
}
class InitDisciplinesState extends DisciplineState {
  InitDisciplinesState({required super.disciplines});

  init() async {
    var list = await handler.rawQuery("select * from discipline;");

    for(var i in list) {
      Discipline discipline = Discipline.fromBdd(map: i);
      if(!disciplines.any((element) => element.id == discipline.id)) {
        disciplines.add(discipline);
      }
    }
  }
}
class RemovedDisciplineState extends DisciplineState {
  RemovedDisciplineState({required super.disciplines});

  remove(Discipline discipline) async {
    await handler.execQuery("delete from discipline where iddiscipline = ${discipline.id}");
    await handler.execQuery("delete from homework where iddiscipline = ${discipline.id}");
    disciplines.remove(discipline);
  }
}
class AddedDisciplineState extends DisciplineState {
  AddedDisciplineState({required super.disciplines});

  add(Discipline discipline) async {
    disciplines.add(discipline);

    await handler.execQuery(
        "insert into discipline (name, semester) values ('${discipline.name}', '${discipline.semester}');"
    );
    discipline.id = (await handler.rawQuery("select iddiscipline from discipline where name = '${discipline.name}';"))[0]["iddiscipline"] as int;
  }
}
class ModifiedDisciplineState extends DisciplineState {
  ModifiedDisciplineState({required super.disciplines});

  modify(Discipline discipline) async {
    await handler.execQuery(
      "update discipline set name = '${discipline.name}',"
          " semester = '${discipline.semester}' where iddiscipline = ${discipline.id};"
    );
  }
}

class DisciplineBloc extends Bloc<DisciplineEvent, DisciplineState> {
  DisciplineBloc() : super(InitDisciplinesState(disciplines: [ ])) {
    on<DisciplineEvent>(onEventDiscipline);
  }

  onEventDiscipline(DisciplineEvent event, Emitter<DisciplineState> emit) async {
    switch(event.runtimeType) {
      case InitDisciplinesEvent:
        InitDisciplinesState nextState = InitDisciplinesState(disciplines: state.disciplines);
        await nextState.init();
        emit(nextState);
        break;
      case RemoveDisciplineEvent:
        RemovedDisciplineState nextState = RemovedDisciplineState(disciplines: state.disciplines);
        nextState.remove((event as RemoveDisciplineEvent).discipline);
        emit(nextState);
        break;
      case AddDisciplineEvent:
        AddedDisciplineState nextState = AddedDisciplineState(disciplines: state.disciplines);
        nextState.add((event as AddDisciplineEvent).discipline);
        emit(nextState);
        break;
      case ModifyNoteEvent:
        ModifiedDisciplineState nextState = ModifiedDisciplineState(disciplines: state.disciplines);
        nextState.modify((event as ModifyNoteEvent).discipline);
        emit(nextState);
        break;
    }
  }
}