import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:hooked_bloc/src/cubit_defaults.dart';
import 'package:hooked_bloc/src/injection/hook_injection_controller.dart';

class HookedBloc {
  static void initialize(
    CubitInjectionFunction injectionFunction, {
    BlocBuilderCondition? builderCondition,
    BlocListenerCondition? listenerCondition,
  }) {
    BlocHookInjectionController.initializeWith(
      injectionFunction,
      builderCondition:
          builderCondition ?? CubitDefaults.alwaysRebuildCondition,
      listenerCondition:
          listenerCondition ?? CubitDefaults.alwaysListenCondition,
    );
  }
}
