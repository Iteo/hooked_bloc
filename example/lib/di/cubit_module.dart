import 'package:example/presentation/counter_cubit.dart';
import 'package:injectable/injectable.dart';

import '../presentation/use_cubit_page.dart';


@module
abstract class CubitModule {
  CounterCubit get counterCubit => CounterCubit("DI");

  SampleCubit get subjectCubit => SampleCubit();
}