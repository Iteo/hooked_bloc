import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/src/injection/bloc_hook_injector_config.dart';

typedef BlocListenerCondition<S> = bool Function(S current);

typedef BlocListener<BLOC extends BlocBase<S>, S> = void Function(
  BLOC cubit,
  S current,
  BuildContext context,
);

/// Calls callback function [listener] each time when [listenWhen] conditions are fulfilled
///
/// [listener] callback function
/// [listenWhen] local filter function, that will pass incoming states from [BlocBase.stream]. By default passes all states.
///
void useCubitListener<BLOC extends BlocBase<S>, S>(
  BLOC bloc,
  BlocListener<BLOC, S> listener, {
  BlocListenerCondition<S>? listenWhen,
}) {
  final context = useContext();
  final configuredListener = useBlocHookInjectorConfig().listenerCondition;
  final listenWhenConditioner = listenWhen ?? configuredListener;

  useMemoized(
    () {
      final stream = bloc.stream.where(listenWhenConditioner).listen(
            (state) => listener(
              bloc,
              state,
              context,
            ),
          );

      return stream.cancel;
    },
    [bloc],
  );
}
