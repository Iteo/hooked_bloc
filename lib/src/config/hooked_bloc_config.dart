import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/src/bloc_builder.dart';
import 'package:hooked_bloc/src/bloc_defaults.dart';
import 'package:hooked_bloc/src/bloc_listener.dart';
import 'package:provider/provider.dart';

typedef BlocInjector = T Function<T extends Object>();
typedef BlocInjectionFunction = BlocInjector Function();

class HookedBlocConfig {
  HookedBlocConfig({
    this.injector,
    BlocBuilderCondition? builderCondition,
    BlocListenerCondition? listenerCondition,
  })  : builderCondition =
            builderCondition ?? BlocDefaults.alwaysRebuildCondition,
        listenerCondition =
            listenerCondition ?? BlocDefaults.alwaysListenCondition;

  HookedBlocConfig._def()
      : injector = null,
        builderCondition = BlocDefaults.alwaysRebuildCondition,
        listenerCondition = BlocDefaults.alwaysListenCondition;

  final BlocInjectionFunction? injector;
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
