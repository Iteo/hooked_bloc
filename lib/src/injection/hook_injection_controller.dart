import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:hooked_bloc/src/cubit_defaults.dart';

typedef CubitInjector = T Function<T extends Object>();
typedef CubitInjectionFunction = CubitInjector Function();

class BlocHookInjectionController {
  static CubitInjectionFunction? _injector;
  static BlocBuilderCondition _builderCondition = CubitDefaults.alwaysRebuildCondition;
  static BlocListenerCondition _listenerCondition = CubitDefaults.alwaysListenCondition;

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
}
