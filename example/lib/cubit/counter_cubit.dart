import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  final String name;

  CounterCubit(this.name) : super(0);

  void init() {}

  void increment() => emit(state + 1);
}
