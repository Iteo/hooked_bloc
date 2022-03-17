import 'package:example/presentation/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectCubit extends Cubit<int> {
  SubjectCubit() : super(0);

  void increment() => emit(state + 1);

  void init() {

  }
}

class UseCubitCounterPage extends HookWidget {
  const UseCubitCounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The hook will provide the expected object
    final cubit = useCubit<SubjectCubit>(
      // Here invoke an initial setup for your Cubit
      onInit: (cubit) => cubit.init(),
    );

    // The state will be updated along with the widget
    final int state = useCubitBuilder(cubit, buildWhen: (_) => true);

    return Scaffold(
      body: Center(
        child: GestureDetector(
          // Interact with your Cubit as always
          onTap: () => cubit.increment(),
          // Display the new data
          child: Text("This text has been clicked $state times."),
        ),
      ),
    );
  }
}
