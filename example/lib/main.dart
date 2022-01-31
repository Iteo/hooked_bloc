import 'package:example/di/injector.dart';
import 'package:example/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

void main() async {
  await configureDependencies();
  HookedBloc.initialize(() => getIt.get);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
