import 'package:bloc/bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/src/injection/hook_injection_controller.dart';

typedef BlocBuilderCondition<S> = bool Function(S current);

S useCubitBuilder<C extends BlocBase, S>(
  BlocBase<S> cubit, {
  BlocBuilderCondition<S>? buildWhen,
}) {
  final buildWhenConditioner =
      buildWhen ?? BlocHookInjectionController.builderCondition;
  final state = useMemoized(
    () => cubit.stream.where(buildWhenConditioner),
    [cubit.state, cubit],
  );

  return useStream(state, initialData: cubit.state, preserveState: false)
      .requireData!;
}
