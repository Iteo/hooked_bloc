import 'package:flutter/material.dart';

class ClickableItemList extends StatelessWidget {
  const ClickableItemList({
    Key? key,
    required this.itemCallback,
    required this.data,
  }) : super(key: key);

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
