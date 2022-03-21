import 'package:hooked_bloc/hooked_bloc.dart';
import 'event_cubit.dart';

// You can use also ActionCubit base class
class MessageActionCubit extends EventCubit with BlocActionMixin<String, BuildState> {

  @override
  void dispatch(String action) {
    super.dispatch(action);
  }
}