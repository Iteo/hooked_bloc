import 'package:example/cubit/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// The page must inherit from HookWidget
class UseBlocBuilderPage extends HookWidget {
  UseBlocBuilderPage({super.key});

  final CounterCubit cubit = CounterCubit("My cubit");

  @override
  Widget build(BuildContext context) {
    // The state will be updated along with the widget
    // For default the state will be updated basing on `builderCondition`
    final int state = useBlocBuilder(cubit);

    return Scaffold(
      appBar: AppBar(title: const Text("useBlocBuilder")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => cubit.increment(),
        child: const Icon(Icons.add),
      ),
      body: Center(child: Text("The button has been pressed $state times")),
    );
  }
}
