import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

import '../cubit/sample_cubit.dart';

// The page must inherit from HookWidget
class UseCubitPage extends HookWidget {
  const UseCubitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The hook will provide the expected object
    final cubit = useBloc<SimpleCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text("useCubit")),
      body: Center(
        child: MaterialButton(
          child: const Text("Click to show cubit name!"),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("This is ${cubit.runtimeType.toString()}")),
          ),
        ),
      ),
    );
  }
}
