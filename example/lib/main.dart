import 'package:example/di/injector.dart';
import 'package:example/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

void main() async {
  // With GetIt or Injectable
  await configureDependencies();

  runApp(
    HookedBlocConfigProvider(
      injector: () => getIt.get,
      builderCondition: (state) => state != null, // Global build condition
      listenerCondition: (state) => state != null, // Global listen condition
      child: const MyApp(),
    ),
  );
}

// Quickstart example counter page
// Remember to inherit from HookWidget
// class MyApp extends HookWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // At start obtain a cubit instance
//     final cubit = useBloc<CounterCubit>();
//     // Then observe state's updates
//     //`buildWhen` param will override builderCondition locally
//     final state = useBlocBuilder(cubit, buildWhen: (state) => state <= 10);
//     // Create a listener for the side-effect
//     useBlocListener(cubit, (cubit, value, context) {
//       print("Button clicked");
//     });
//
//     // Build widget's tree without BlocProvider
//     return MaterialApp(
//       home: Scaffold(
//         floatingActionButton: FloatingActionButton(
//           onPressed: () => cubit.increment(), // Access cubit in tree
//           child: const Icon(Icons.add),
//         ),
//         // Consume state without BlocBuilder
//         body: Center(child: Text("The button has been pressed $state times")),
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final appName = "Hooked Bloc";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(title: appName),
    );
  }
}
