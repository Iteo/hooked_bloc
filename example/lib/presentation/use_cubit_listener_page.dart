import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowMessage extends BuildState {
  final String message;

  ShowMessage(this.message);
}

class UpdateScreen extends BuildState {
  final int counter;

  UpdateScreen(this.counter);
}

// For default when you don't specify buildWhen for your useCubitBuilder,
// you must set base class for state as a BuildState!
class EventCubit extends Cubit<BuildState> {
  EventCubit() : super(UpdateScreen(0));

  var _counter = 0;

  void showMessage(String message) {
    emit(ShowMessage(message));
    print(message);
  }

  void increment() {
    _counter += 1;
    emit(UpdateScreen(_counter));
    print(_counter);
  }
}

// The page must inherit from HookWidget
class UseCubitListenerPage extends StatelessWidget {
  UseCubitListenerPage({Key? key}) : super(key: key);

  final EventCubit cubit = EventCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("useCubitListener")),
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
            onPressed: () => cubit.showMessage("New message"),
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

  final EventCubit cubit;

  @override
  Widget build(BuildContext context) {
    // Handle state as event independently of the view state
    useCubitListener(cubit, (_, value, context) {
      _showMessage(context, (value as ShowMessage).message);
    }, listenWhen: (state) => state is ShowMessage);

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
          builder: (_) => Text(message ?? "Some message"),
        ),
      ),
    );
  }
}
