import 'package:hooked_bloc/src/mixins/bloc_action_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Syntactic sugar for [Bloc] with [BlocActionMixin]
///
/// [BlocActionMixin] is useful while adding events to the existing Cubits
/// Creating new Cubit with actions stream, can be done by extending [ActionCubit]:
///
///```dart
/// class MessageActionBloc extends ActionBloc<BuildState, int, String>{
///   MessageActionBloc(BuildState initialState) : super(initialState);
///
///   @override
///   void dispatch(String action) {
///     super.dispatch(action);
///   }
/// }
///```
abstract class ActionBloc<STATE, EVENT, ACTION> extends Bloc<EVENT, STATE>
    with BlocActionMixin<ACTION, STATE> {
  ActionBloc(super.initialState);
}
