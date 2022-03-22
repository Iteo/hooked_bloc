import 'package:flutter/material.dart';

class ItemDetail extends StatelessWidget {
  const ItemDetail({
    Key? key,
    required this.index,
    required this.onClose,
  }) : super(key: key);

  final int index;
  final Function() onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Item $index"),
          const Text("Now you can see the details of an item"),
          MaterialButton(
              child: const Text("Close"), onPressed: () => onClose()),
        ],
      ),
    );
  }
}
