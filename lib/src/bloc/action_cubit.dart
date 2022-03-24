import 'package:hooked_bloc/src/mixins/bloc_action_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Syntactic sugar for [Cubit] with [BlocActionMixin]
///
/// [BlocActionMixin] is useful while adding events to the existing Cubits
/// Creating new Cubit with actions stream, can be done by extending [ActionCubit]:
///
///```dart
/// class MessageActionCubit extends ActionCubit<BuildState, String> {
///   MessageActionCubit(BuildState initialState) : super(initialState);
///
///   @override
///   void dispatch(String action) {
///     super.dispatch(action);
///   }
/// }
///```
abstract class ActionCubit<STATE extends Object, ACTION> extends BlocBase<STATE>
    with BlocActionMixin<ACTION, STATE> {
  ActionCubit(STATE initialState) : super(initialState);
}
