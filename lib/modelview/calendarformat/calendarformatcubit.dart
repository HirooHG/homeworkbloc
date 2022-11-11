
import 'package:bloc/bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarFormatCubit extends Cubit<CalendarFormat> {
  CalendarFormatCubit() : super(CalendarFormat.month);

  changeFormat(CalendarFormat format) {
    emit(format);
  }
}