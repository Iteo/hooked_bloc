import 'package:flutter/material.dart';

class ClickableItemList extends StatelessWidget {
  const ClickableItemList({
    super.key,
    required this.itemCallback,
    required this.data,
  });

  final Function(int) itemCallback;
  final List<String> data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...data.map((item) => ListTile(
              onTap: () => itemCallback(data.indexOf(item)),
              title: Text(item),
            ))
      ],
    );
  }
}
