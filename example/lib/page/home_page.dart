import 'package:example/page/real_life_hook_page.dart';
import 'package:flutter/material.dart';
import '../page/real_life_page.dart';
import '../page/use_action_listener_page.dart';
import '../page/use_cubit_builder_page.dart';
import '../page/use_cubit_listener_page.dart';
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
              onPressed: () =>
                  _navigateToPage(context, UseActionListenerPage()),
            ),
            MaterialButton(
              child: const Text("Real life example"),
              onPressed: () => _navigateToPage(context, const RealLifePage()),
            ),
            MaterialButton(
              child: const Text("Real life example with hooks"),
              onPressed: () =>
                  _navigateToPage(context, const RealLifeHookPage()),
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
