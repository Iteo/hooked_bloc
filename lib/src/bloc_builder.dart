import 'package:bloc/bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:hooked_bloc/src/cubit_defaults.dart';

typedef BlocBuilderCondition<S> = bool Function(S current);

typedef CubitBuilderAttachedCommand<T extends BlocBase> = DisposeCommand? Function(T cubit);

S useCubitBuilder<C extends BlocBase<S>, S>(
  C cubit, {
  BlocBuilderCondition<S>? buildWhen,
  CubitBuilderAttachedCommand<C>? onAttached,
}) {
  final buildWhenConditioner = buildWhen ?? CubitDefaults.defaultBlocBuilderCondition;
  final state = useMemoized(
    () => cubit.stream.where(buildWhenConditioner),
    [cubit.state],
  );

  useEffect(() {
    final dispose = onAttached?.call(cubit);
    return dispose;
  }, [cubit]);

  return useStream(state, initialData: cubit.state).requireData!;
}
