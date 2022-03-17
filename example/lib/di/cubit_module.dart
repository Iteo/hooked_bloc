import 'package:example/cubit/counter_cubit.dart';
import 'package:injectable/injectable.dart';

import '../cubit/action_cubit.dart';
import '../cubit/event_cubit.dart';
import '../cubit/sample_cubit.dart';

@module
abstract class CubitModule {
  CounterCubit get counterCubit => CounterCubit("DI");

  SimpleCubit get simpleCubit => SimpleCubit();

  EventCubit get eventCubit => EventCubit();

  MessageActionCubit get messageActionCubit => MessageActionCubit();
}
