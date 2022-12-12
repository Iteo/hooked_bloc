import 'package:bloc/bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:hooked_bloc/src/config/hooked_bloc_config.dart';

typedef BlocComparativeBuilderCondition<S> = bool Function(
  S previous,
  S current,
);

/// Returns current state of BlocBase class basing on state's comparison
///
/// The [useBlocComparativeBuilder] will filter any state,
/// via specified [buildWhen] parameter.
///
/// For building bloc's state without condition, see [useBlocBuilder].
///
/// [buildWhen] local filter function, that will filter incoming states
/// from [BlocBase.stream] with access to the previous and current value.
S useBlocComparativeBuilder<C extends BlocBase, S>(
  BlocBase<S> bloc, {
  required BlocComparativeBuilderCondition<S> buildWhen,
}) {
  // The stream doesn't support filtering with the previous and current value
  // We have to manually store previous value, especially for initial state
  final currentState = useRef(bloc.state);

  final state = useMemoized(
    () => bloc.stream.where(
      (nextState) {
        final shouldRebuild = buildWhen(currentState.value, nextState);
        currentState.value = nextState;
        return shouldRebuild;
      },
    ),
    [bloc],
  );

  return useStream(
    state,
    initialData: bloc.state,
    preserveState: false,
  ).requireData!;
}
