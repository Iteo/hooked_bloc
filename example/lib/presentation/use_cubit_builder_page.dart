import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'counter_cubit.dart';

// The page must inherit from HookWidget
class UseCubitBuilderPage extends HookWidget {
  UseCubitBuilderPage({Key? key}) : super(key: key);

  final CounterCubit cubit = CounterCubit("My cubit");

  @override
  Widget build(BuildContext context) {
    // The state will be updated along with the widget
    final int state = useCubitBuilder(cubit, buildWhen: (_) => true);

    return Scaffold(
      appBar: AppBar(title: const Text("useCubitBuilder")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => cubit.increment(),
        child: const Icon(Icons.add),
      ),
      body: Center(child: Text("The button has been pressed $state times")),
    );
  }
}
