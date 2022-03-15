import 'package:example/presentation/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return CounterCubit("Provider");
      },
      child: const _HomePageContentBlocBuilder(),
    );
  }
}

class _HomePageContentHooks extends HookWidget {
  const _HomePageContentHooks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CounterCubit cubit = useCubit<CounterCubit>();
    final int state = useCubitBuilder(cubit, buildWhen: (_) => true);

    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(child: Text('$state')),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: cubit.increment,
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: cubit.decrement,
          ),
        ],
      ),
    );
  }
}

class _HomePageContentBlocBuilder extends StatelessWidget {
  const _HomePageContentBlocBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: BlocBuilder<CounterCubit, int>(
        builder: (context, count) => Center(
          child: Text('$count'),
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => context.read<CounterCubit>().increment(),
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: () => context.read<CounterCubit>().decrement(),
          ),
        ],
      ),
    );
  }
}
