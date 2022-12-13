import 'package:example/cubit/sample_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

// The page must inherit from HookWidget
class UseBlocPage extends HookWidget {
  const UseBlocPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The hook will provide the expected object
    final cubit = useBloc<SimpleCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text("useBloc")),
      body: Center(
        child: MaterialButton(
          child: const Text("Click to show bloc name!"),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("This is ${cubit.runtimeType.toString()}")),
          ),
        ),
      ),
    );
  }
}
