import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:hooked_bloc/src/cubit_defaults.dart';
import 'package:hooked_bloc/src/injection/bloc_hook_injector_config.dart';
import 'package:meta/meta.dart';

class BlocHookInjectionController {
  static CubitInjectionFunction? _injector;
  static BlocBuilderCondition _builderCondition =
      CubitDefaults.alwaysRebuildCondition;
  static BlocListenerCondition _listenerCondition =
      CubitDefaults.alwaysListenCondition;

  static void initializeWith<T>(
    CubitInjectionFunction injector, {
    required BlocBuilderCondition builderCondition,
    required BlocListenerCondition listenerCondition,
  }) {
    BlocHookInjectionController._injector = injector;
    BlocHookInjectionController._builderCondition = builderCondition;
    BlocHookInjectionController._listenerCondition = listenerCondition;
  }

  static CubitInjectionFunction? get injector => _injector;

  static BlocBuilderCondition get builderCondition => _builderCondition;

  static BlocListenerCondition get listenerCondition => _listenerCondition;

  @visibleForTesting
  static void cleanUp() {
    BlocHookInjectionController._injector = null;
  }
}
