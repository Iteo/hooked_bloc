import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../cubit/action_cubit.dart';
import '../cubit/event_cubit.dart';

// The page must inherit from HookWidget
class UseActionListenerPage extends StatelessWidget {
  UseActionListenerPage({Key? key}) : super(key: key);

  final MessageActionCubit cubit = MessageActionCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("useActionListener")),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            key: const Key("FAB increment"),
            onPressed: () => cubit.increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox.square(dimension: 24, child: Divider()),
          FloatingActionButton(
            key: const Key("FAB message"),
            onPressed: () => cubit.dispatch("This message is shown only once"),
            child: const Icon(Icons.chat),
          ),
        ],
      ),
      body: _ScaffoldBody(cubit: cubit),
    );
  }
}

class _ScaffoldBody extends HookWidget {
  const _ScaffoldBody({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  final MessageActionCubit cubit;

  @override
  Widget build(BuildContext context) {
    // Handle separate action stream with values other than a state type
    useActionListener(cubit, (String action) {
      _showMessage(context, action);
    });

    final state = useCubitBuilder(cubit, buildWhen: (st) => st is UpdateScreen);
    // Because of the buildWhen, we are sure about state type
    final count = (state as UpdateScreen).counter;

    return Center(child: Text("The button has been pressed $count times"));
  }

  _showMessage(BuildContext context, String? message) {
    Scaffold.of(context).showBottomSheet(
      (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: BottomSheet(
          onClosing: () {},
          builder: (_) => Text(message ?? ""),
        ),
      ),
    );
  }
}
