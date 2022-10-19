import 'package:flutter/material.dart';
import 'package:homeworkbloc/homeworkapp.dart';
import 'modelview/blocobserver.dart';
import 'package:bloc/bloc.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const HomeworkApp());
}