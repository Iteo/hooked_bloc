import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/src/mixins/bloc_action_mixin.dart';

typedef OnActionCallback<T> = Function(T action);

void useActionListener<ACTION>(
  BlocActionMixin<ACTION, Object> actionMixin,
  OnActionCallback<ACTION> onAction,
) {
  useEffect(() {
    final subscription = actionMixin.actions.listen(onAction);

    return subscription.cancel;
  });
}
