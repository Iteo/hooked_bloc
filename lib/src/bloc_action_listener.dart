import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

typedef OnActionCallback<T> = Function(T action);

typedef ActionListenerCondition<T> = bool Function(T? previousAction, T action);

/// Calls callback function [onAction] each time, when new action is dispatched from [BlocBase] with [BlocActionMixin], [ActionCubit] or [ActionBloc]
void useActionListener<ACTION>(
  BlocActionMixin<ACTION, Object> actionMixin,
  OnActionCallback<ACTION> onAction, {
  ActionListenerCondition<ACTION>? actionWhen,
}) {
  useEffect(
    () {
      final subscription = actionMixin.actions.listen((action) {
        if(actionWhen == null || actionWhen(actionMixin.previousAction, action)) {
          onAction(action);
        }
      });
      return subscription.cancel;
    },
    [actionMixin],
  );
}
