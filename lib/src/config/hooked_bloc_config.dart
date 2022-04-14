import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/src/bloc_builder.dart';
import 'package:hooked_bloc/src/bloc_listener.dart';
import 'package:hooked_bloc/src/cubit_defaults.dart';
import 'package:provider/provider.dart';

typedef CubitInjector = T Function<T extends Object>();
typedef CubitInjectionFunction = CubitInjector Function();

class HookedBlocConfig {
  HookedBlocConfig({
    this.injector,
    BlocBuilderCondition? builderCondition,
    BlocListenerCondition? listenerCondition,
  })  : builderCondition =
            builderCondition ?? CubitDefaults.alwaysRebuildCondition,
        listenerCondition =
            listenerCondition ?? CubitDefaults.alwaysListenCondition;

  HookedBlocConfig._def()
      : injector = null,
        builderCondition = CubitDefaults.alwaysRebuildCondition,
        listenerCondition = CubitDefaults.alwaysListenCondition;

  final CubitInjectionFunction? injector;
  final BlocBuilderCondition builderCondition;
  final BlocListenerCondition listenerCondition;
}

HookedBlocConfig useHookedBlocConfig() {
  final context = useContext();
  try {
    return context.read<HookedBlocConfig>();
  } catch (_) {
    return HookedBlocConfig._def();
  }
}
