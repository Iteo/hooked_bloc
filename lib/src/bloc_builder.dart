import 'package:bloc/bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/src/config/hooked_bloc_config.dart';

typedef BlocBuilderCondition<S> = bool Function(S current);

/// Returns current state of BlocBase class
///
/// By default [useBlocBuilder] will not filter any states, unless specified [buildWhen] parameter or [builderCondition] in [HookedBloc.initialize]
/// [buildWhen] local filter function, that will filter incoming states from [BlocBase.stream]
S useBlocBuilder<C extends BlocBase, S>(
  BlocBase<S> bloc, {
  BlocBuilderCondition<S>? buildWhen,
}) {
  final configuredBuildWhen = useHookedBlocConfig().builderCondition;
  final buildWhenConditioner = buildWhen ?? configuredBuildWhen;
  final state = useMemoized(
    () => bloc.stream.where(buildWhenConditioner),
    [bloc],
  );

  return useStream(
    state,
    initialData: bloc.state,
    preserveState: false,
  ).requireData!;
}
