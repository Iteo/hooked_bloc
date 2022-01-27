import 'package:bloc/bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/src/cubit_defaults.dart';

typedef BlocBuilderCondition<S> = bool Function(S current);

S useCubitBuilder<C extends BlocBase, S>(
  BlocBase<S> cubit, {
  BlocBuilderCondition<S>? buildWhen,
}) {
  final buildWhenConditioner = buildWhen;
  final state = useMemoized(
    () => cubit.stream.where(buildWhenConditioner ?? CubitDefaults.defaultBlocBuilderCondition),
    [cubit.state],
  );

  return useStream(state, initialData: cubit.state).requireData!;
}
