import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

typedef OnActionCallback<T> = Function(T action);

/// Calls callback function [onAction] each time, when new action is dispatched from [BlocBase] with [BlocActionMixin], [ActionCubit] or [ActionBloc]
void useActionListener<ACTION>(
  BlocActionMixin<ACTION, Object> actionMixin,
  OnActionCallback<ACTION> onAction,
) {
  useEffect(() {
    final subscription = actionMixin.actions.listen(onAction);

    return subscription.cancel;
  }, [actionMixin]);
}
