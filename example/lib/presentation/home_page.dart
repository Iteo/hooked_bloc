import 'package:example/presentation/use_action_listener_page.dart';
import 'package:example/presentation/use_cubit_builder_page.dart';
import 'package:example/presentation/use_cubit_listener_page.dart';
import 'package:flutter/material.dart';

import 'use_cubit_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              child: const Text("Show useCubit usage"),
              onPressed: () => _navigateToPage(context, const UseCubitPage()),
            ),
            MaterialButton(
              child: const Text("Show useCubitBuilder usage"),
              onPressed: () => _navigateToPage(context, UseCubitBuilderPage()),
            ),
            MaterialButton(
              child: const Text("Show useCubitListener usage"),
              onPressed: () => _navigateToPage(context, UseCubitListenerPage()),
            ),
            MaterialButton(
              child: const Text("Show useActionListener usage"),
              onPressed: () => _navigateToPage(context, UseActionListenerPage()),
            )
          ],
        ),
      ),
    );
  }

  _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
