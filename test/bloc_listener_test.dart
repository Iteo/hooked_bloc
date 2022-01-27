import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

import 'mock.dart';

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: CounterCubit(),
      child: const TestListenerWidget(),
    );
  }
}

class TestListenerWidget extends HookWidget {
  const TestListenerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<CounterCubit>();
    return Container();
  }
}

void main() {
  group('Bloc Listener', () {

    testWidgets('', (tester) async {

    });


  });
}
