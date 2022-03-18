import 'package:flutter/material.dart';

class ItemDetailDialog extends StatelessWidget {
  const ItemDetailDialog({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Item $index"),
      content: const Text("Now you can see the details of item"),
    );
  }
}
