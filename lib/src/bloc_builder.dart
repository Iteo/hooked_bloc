import 'package:bloc/bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:hooked_bloc/src/injection/hook_injection_controller.dart';

typedef BlocBuilderCondition<S> = bool Function(S current);

/// Returns current state of BlocBase class
///
/// By default [useCubitBuilder] will not filter any states, unless specified [buildWhen] parameter or [builderCondition] in [HookedBloc.initialize]
/// [buildWhen] local filter function, that will filter incoming states from [BlocBase.stream]
S useCubitBuilder<C extends BlocBase, S>(
  BlocBase<S> cubit, {
  BlocBuilderCondition<S>? buildWhen,
}) {
  final buildWhenConditioner =
      buildWhen ?? BlocHookInjectionController.builderCondition;
  final state = useMemoized(
    () => cubit.stream.where(buildWhenConditioner),
    [cubit],
  );

  return useStream(state, initialData: cubit.state, preserveState: false)
      .requireData!;
}
