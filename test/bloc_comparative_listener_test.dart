import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

import 'mock.dart';

const _incrementKey = "cubit_listener_increment_button";
const _reEmitKey = "cubit_listener_re_emit_state";

class CounterCubit extends Cubit<int> {
  CounterCubit({int seed = 0}) : super(seed);

  void increment() => emit(state + 1);

  void reEmit() => emit(state);
}

class MyApp extends HookWidget {
  const MyApp({
    Key? key,
    this.onListenerCalled,
    required this.cubit,
    required this.listenWhen,
  }) : super(key: key);

  final BlocWidgetListener<int>? onListenerCalled;
  final CounterCubit cubit;
  final bool Function(int previous, int current) listenWhen;

  @override
  Widget build(BuildContext context) {
    useBlocComparativeListener<CounterCubit, int>(
      cubit,
      (cubit, currentState, context) {
        onListenerCalled?.call(context, currentState);
      },
      listenWhen: listenWhen,
    );

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            ElevatedButton(
              key: const Key(_reEmitKey),
              onPressed: cubit.reEmit,
              child: const SizedBox(),
            ),
            ElevatedButton(
              key: const Key(_incrementKey),
              onPressed: cubit.increment,
              child: const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  group('Bloc Comparative Listener', () {
    testWidgets('should call callback, each time when listenWhen returns true',
        (tester) async {
      final cubit = CounterCubit();

      final incrementFinder = find.byKey(
        const Key(_incrementKey),
      );

      int listenerCalls = 0;

      await tester.pumpWidget(
        MyApp(
          cubit: cubit,
          onListenerCalled: (_, int state) {
            listenerCalls++;
          },
          listenWhen: (previous, current) => true,
        ),
      );

      await tester.tap(incrementFinder);
      expect(listenerCalls, 1);

      await tester.tap(incrementFinder);
      expect(listenerCalls, 2);
    });

    testWidgets('should not call callback, when the same state is emitted',
        (tester) async {
      final cubit = CounterCubit();

      final incrementFinder = find.byKey(
        const Key(_incrementKey),
      );
      final reEmitFinder = find.byKey(
        const Key(_reEmitKey),
      );

      int listenerCalls = 0;

      await tester.pumpWidget(
        MyApp(
          cubit: cubit,
          onListenerCalled: (_, int state) {
            listenerCalls++;
          },
          listenWhen: (previous, current) => true,
        ),
      );

      await tester.tap(incrementFinder);
      expect(listenerCalls, 1);

      await tester.tap(reEmitFinder);
      await tester.pump();
      await tester.tap(reEmitFinder);
      await tester.pump();
      await tester.tap(reEmitFinder);
      await tester.pump();
      await tester.tap(reEmitFinder);
      await tester.pump();

      expect(listenerCalls, 1);
      await tester.tap(incrementFinder);
      expect(listenerCalls, 2);
    });

    testWidgets(
        'should call callback, when state is not skipped by listenWhen conditions',
        (tester) async {
      final cubit = CounterCubit();
      const skipStates = [1, 2, 3, 5, 6];

      final incrementFinder = find.byKey(
        const Key(_incrementKey),
      );

      int listenerCalls = 0;

      await tester.pumpWidget(
        MyApp(
          cubit: cubit,
          onListenerCalled: (_, int state) {
            listenerCalls++;
          },
          listenWhen: (previousState, currentState) =>
              !skipStates.contains(currentState),
        ),
      );

      await tester.tap(incrementFinder); //1
      await tester.tap(incrementFinder); //2
      await tester.tap(incrementFinder); //3
      expect(listenerCalls, 0);

      await tester.tap(incrementFinder); //4
      expect(listenerCalls, 1);

      await tester.tap(incrementFinder); //5
      await tester.tap(incrementFinder); //6
      expect(listenerCalls, 1);
      await tester.tap(incrementFinder); //7
      expect(listenerCalls, 2);
      await tester.tap(incrementFinder); //8
      expect(listenerCalls, 3);
    });

    testWidgets('should not call callback when listenWhen return false',
        (tester) async {
      final cubit = CounterCubit();

      final incrementFinder = find.byKey(
        const Key(_incrementKey),
      );

      int listenerCalls = 0;

      await tester.pumpWidget(
        MyApp(
          cubit: cubit,
          onListenerCalled: (_, int state) {
            listenerCalls++;
          },
          listenWhen: (previous, current) => false,
        ),
      );

      await tester.tap(incrementFinder);
      expect(listenerCalls, 0);

      await tester.tap(incrementFinder);
      expect(listenerCalls, 0);
    });
  });

  group('Bloc Listener, with global initializer', () {
    late Injector injector;

    setUp(() {
      injector = MockedInjector();
    });

    testWidgets(
        'should  call callback, when all events are blocked by listenerCondition but condition function is overridden by listenWhen ',
        (tester) async {
      final cubit = CounterCubit();

      final incrementFinder = find.byKey(
        const Key(_incrementKey),
      );

      int listenerCalls = 0;

      await tester.pumpWidget(
        HookedBlocConfigProvider(
          injector: () => injector.get,
          listenerCondition: (_) => false,
          child: MyApp(
            cubit: cubit,
            onListenerCalled: (_, int state) {
              listenerCalls++;
            },
            listenWhen: (previous, current) => true,
          ),
        ),
      );

      await tester.tap(incrementFinder);
      await tester.tap(incrementFinder);
      await tester.tap(incrementFinder);
      expect(listenerCalls, 3);
    });
  });
}
