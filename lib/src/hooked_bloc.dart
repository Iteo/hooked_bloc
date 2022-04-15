import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:hooked_bloc/src/config/hooked_bloc_config.dart';
import 'package:provider/provider.dart';

/// [HookedBlocConfigProvider] provides you a way to setup widget tree scoped [HookedBlocConfig] for cubit hooks
///
/// [injector] used by [useBloc] provides required [BlocBase] class.
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
/// [builderCondition] sets global `buildWhen` methods. Used by [useBlocBuilder].
/// Can be overridden by buildWhen parameter from [useBlocBuilder]
/// Default implementation pass all states (state) => true
///
/// [listenerCondition] sets global `listenWhen` methods. Used by [useBlocListener].
/// Can be overridden by listenWhen parameter from [useBlocListener]
/// Default implementation pass all states (state) => true
class HookedBlocConfigProvider extends StatelessWidget {
  const HookedBlocConfigProvider({
    required this.child,
    this.injector,
    this.builderCondition,
    this.listenerCondition,
    Key? key,
  }) : super(key: key);

  final BlocInjectionFunction? injector;
  final BlocBuilderCondition? builderCondition;
  final BlocListenerCondition? listenerCondition;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final config = HookedBlocConfig(
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
