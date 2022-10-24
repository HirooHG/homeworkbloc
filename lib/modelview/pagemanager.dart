
import 'package:bloc/bloc.dart';

class PageManagerCubit extends Cubit<int> {
  PageManagerCubit() : super(0);

  change(int value) => emit(value);
}