import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef BlocComparativeListenerCondition<S> = bool Function(
  S previous,
  S current,
);

typedef BlocComparativeListener<BLOC extends BlocBase<S>, S> = void Function(
  BLOC bloc,
  S current,
  BuildContext context,
);

void useBlocComparativeListener<BLOC extends BlocBase<S>, S>(
  BLOC bloc,
  BlocComparativeListener<BLOC, S> listener, {
  required BlocComparativeListenerCondition<S> listenWhen,
}) {
  final currentState = useRef(bloc.state);
  final context = useContext();

  useMemoized(
    () {
      final stream = bloc.stream.where(
        (nextState) {
          final shouldInvokeAction = listenWhen(currentState.value, nextState);
          currentState.value = nextState;
          return shouldInvokeAction;
        },
      ).listen((state) {
        return listener(
          bloc,
          state,
          context,
        );
      });

      return stream.cancel;
    },
    [bloc],
  );
}
