import 'package:example/page/real_life_hook_page.dart';
import 'package:example/page/use_bloc_comparative_builder_page.dart';
import 'package:example/page/real_life_page.dart';
import 'package:example/page/use_action_listener_page.dart';
import 'package:example/page/use_bloc_builder_page.dart';
import 'package:example/page/use_bloc_comparative_listener_page.dart';
import 'package:example/page/use_bloc_listener_page.dart';
import 'package:flutter/material.dart';
import 'use_bloc_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

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
              child: const Text("Show useBloc usage"),
              onPressed: () => _navigateToPage(
                context,
                const UseBlocPage(),
              ),
            ),
            MaterialButton(
              child: const Text("Show useBlocBuilder usage"),
              onPressed: () => _navigateToPage(
                context,
                UseBlocBuilderPage(),
              ),
            ),
            MaterialButton(
              child: const Text("Show useBlocComparativeBuilder usage"),
              onPressed: () => _navigateToPage(
                context,
                UseBlocComparativeBuilderPage(),
              ),
            ),
            MaterialButton(
              child: const Text("Show useBlocListener usage"),
              onPressed: () => _navigateToPage(
                context,
                UseBlocListenerPage(),
              ),
            ),
            MaterialButton(
              child: const Text("Show useBlocComparativeListener usage"),
              onPressed: () => _navigateToPage(
                context,
                UseBlocComparativeListenerPage(),
              ),
            ),
            MaterialButton(
              child: const Text("Show useActionListener usage"),
              onPressed: () =>
                  _navigateToPage(context, UseActionListenerPage()),
            ),
            MaterialButton(
              child: const Text("Real life example"),
              onPressed: () => _navigateToPage(
                context,
                const RealLifePage(),
              ),
            ),
            MaterialButton(
              child: const Text("Real life example with hooks"),
              onPressed: () => _navigateToPage(
                context,
                const RealLifeHookPage(),
              ),
            )
          ],
        ),
      ),
    );
  }

  _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
