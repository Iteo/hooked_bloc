import 'package:flutter/material.dart';

class FabActionsScaffold extends StatelessWidget {
  const FabActionsScaffold({
    Key? key,
    required this.title,
    required this.count,
    required this.incrementCallback,
    required this.messageCallback,
  }) : super(key: key);

  final String title;
  final int count;
  final Function incrementCallback;
  final Function(String) messageCallback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: const ValueKey("FAB increment tag"),
            key: const Key("FAB increment"),
            onPressed: () => incrementCallback(),
            child: const Icon(Icons.add),
          ),
          const SizedBox.square(
            dimension: 24,
            child: Divider(),
          ),
          FloatingActionButton(
            heroTag: const ValueKey("FAB message tag"),
            key: const Key("FAB message"),
            onPressed: () => messageCallback("New message"),
            child: const Icon(Icons.chat),
          ),
        ],
      ),
      body: Center(child: Text("The button has been pressed $count times")),
    );
  }
}
