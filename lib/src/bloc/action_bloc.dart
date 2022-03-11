import 'package:hooked_bloc/src/mixins/bloc_action_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ActionBloc<STATE extends Object, EVENT,  ACTION> extends Bloc<EVENT, STATE> with BlocActionMixin<ACTION, STATE>{
  ActionBloc(STATE initialState) : super(initialState);
}
