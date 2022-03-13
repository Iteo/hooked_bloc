import 'package:hooked_bloc/src/mixins/bloc_action_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ActionCubit<STATE extends Object, ACTION> extends BlocBase<STATE> with BlocActionMixin<ACTION, STATE>{
  ActionCubit(STATE initialState) : super(initialState);
}
