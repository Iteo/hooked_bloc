import 'package:example/cubit/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

class UseBlocComparativeBuilderPage extends HookWidget {
  UseBlocComparativeBuilderPage({Key? key}) : super(key: key);

  final CounterCubit cubit = CounterCubit("My cubit");

  @override
  Widget build(BuildContext context) {
    // The state will be updated along with the widget
    // We can compare state's changes to allow rebuild
    final state = useBlocComparativeBuilder(
      cubit,
      buildWhen: (int previous, int current) {
        return current != previous;
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("useBlocComparativeBuilder")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => cubit.increment(),
        child: const Icon(Icons.add),
      ),
      body: Center(child: Text("The button has been pressed $state times")),
    );
  }
}
