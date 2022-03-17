import 'package:example/presentation/counter_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../use_cubit_page.dart';


@module
abstract class CubitModule {
  CounterCubit get counterCubit => CounterCubit("DI");

  SubjectCubit get subjectCubit => SubjectCubit();
}