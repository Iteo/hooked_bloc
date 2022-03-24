import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/src/injection/hook_injection_controller.dart';

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
  final listenWhenConditioner = listenWhen;
  useMemoized(
    () {
      final stream = bloc.stream
          .where(listenWhenConditioner ??
              BlocHookInjectionController.listenerCondition)
          .listen((state) => listener(
                bloc,
                state,
                context,
              ));

      return stream.cancel;
    },
    [bloc],
  );
}
