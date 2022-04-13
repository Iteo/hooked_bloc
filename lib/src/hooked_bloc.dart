import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:hooked_bloc/src/cubit_defaults.dart';
import 'package:hooked_bloc/src/injection/hook_injection_controller.dart';

///The entry point for [HookedBloc]
class HookedBloc {
  /// Initialize [HookedBloc] with default [BlocBase] injection function. This method call is not required. Can be omitted.
  /// If so, [HookedBloc] will use default [injectionFunction], [builderCondition] and [listenerCondition]
  ///
  /// [injectionFunction] used by [useCubit] provides required [BlocBase] class.
  /// Default implementation tries to find correct [BlocBase] class in widget tree using [Provider.of]
  /// You can easily hooked up this function with other DI/Service locator libraries like GetIt, like so:
  /// ```dart
  /// HookedBloc.initialize(() => getIt);
  ///```
  ///
  /// or setup own provider:
  /// ```dart
  /// HookedBloc.initialize(() {
  ///   return <T extends Object>() {
  ///     if (T == MyCubit) {
  ///       return MyCubit() as T;
  ///     } else {
  ///       return ...
  ///     }
  ///   };
  /// });
  ///```
  /// [builderCondition] sets global `buildWhen` methods. Used by [useCubitBuilder].
  /// Can be overridden by buildWhen parameter from [useCubitBuilder]
  /// Default implementation pass all states (state) => true
  ///
  /// [listenerCondition] sets global `listenWhen` methods. Used by [useCubitListener].
  /// Can be overridden by listenWhen parameter from [useCubitListener]
  /// Default implementation pass all states (state) => true
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
