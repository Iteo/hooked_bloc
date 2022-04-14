import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:hooked_bloc/src/injection/bloc_hook_injector_config.dart';
import 'package:provider/provider.dart';

/// [HookedBlocInjector] provides you a way to setup widget tree scoped [BlocHookInjectorConfig] for cubit hooks
///
/// [injector] used by [useCubit] provides required [BlocBase] class.
/// Default implementation tries to find correct [BlocBase] class in widget tree using [Provider.of]
/// 
/// You can easily hooked up this function with other DI/Service locator libraries like GetIt, like so:
/// ```dart
/// HookedBlocInjector(
///   injector: () => getIt,
///   child: MaterialApp(
///     ...
///   ),
/// )
///```
///
/// or setup own provider:
/// ```dart
/// HookedBlocInjector(
///   injector: () {
///     return <T extends Object>() {
///       if (T == MyCubit) {
///         return MyCubit() as T;
///       } else {
///         return ...
///       }
///     };
///   },
///   child: MaterialApp(
///     ...
///   ),
/// )
///```
///
/// [builderCondition] sets global `buildWhen` methods. Used by [useCubitBuilder].
/// Can be overridden by buildWhen parameter from [useCubitBuilder]
/// Default implementation pass all states (state) => true
///
/// [listenerCondition] sets global `listenWhen` methods. Used by [useCubitListener].
/// Can be overridden by listenWhen parameter from [useCubitListener]
/// Default implementation pass all states (state) => true
class HookedBlocInjector extends StatelessWidget {
  const HookedBlocInjector({
    required this.child,
    this.injector,
    this.builderCondition,
    this.listenerCondition,
    Key? key,
  }) : super(key: key);

  final CubitInjectionFunction? injector;
  final BlocBuilderCondition? builderCondition;
  final BlocListenerCondition? listenerCondition;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final config = BlocHookInjectorConfig(
      injector: injector,
      builderCondition: builderCondition,
      listenerCondition: listenerCondition,
    );
    return Provider.value(
      value: config,
      child: child,
    );
  }
}
