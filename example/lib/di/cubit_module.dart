import 'package:example/presentation/counter_cubit.dart';
import 'package:injectable/injectable.dart';

@module
abstract class CubitModule {
  CounterCubit get counterCubit => CounterCubit("DI");
}