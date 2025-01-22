import 'package:flutter/material.dart';

class MessageBottomSheetContent extends StatelessWidget {
  const MessageBottomSheetContent({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BottomSheet(
        onClosing: () {},
        builder: (_) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(message ?? ""),
        ),
      ),
    );
  }
}
