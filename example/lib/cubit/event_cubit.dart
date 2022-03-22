import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowMessage extends BuildState {
  final String message;

  ShowMessage(this.message);
}

class UpdateScreen extends BuildState {
  final int counter;

  UpdateScreen(this.counter);
}

class EventCubit extends Cubit<BuildState> {
  EventCubit() : super(UpdateScreen(0));

  var _counter = 0;

  void showMessage(String message) {
    emit(ShowMessage(message));
  }

  void increment() {
    _counter += 1;
    emit(UpdateScreen(_counter));
  }
}
