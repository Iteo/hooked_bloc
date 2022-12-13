import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit({int seed = 0}) : super(seed);

  void increment() => emit(state + 1);
}

abstract class AbstractState {}

class TestState extends AbstractState {
  final int _val;

  TestState(this._val);

  int get value => _val;
}

class TestBuildState extends AbstractState implements BuildState {}

class ComplexCubit extends Cubit<TestState> {
  ComplexCubit({required TestState seed}) : super(seed);

  void increment() => emit(TestState(state.value + 1));
}

class AbstractStateCubit extends Cubit<AbstractState> {
  AbstractStateCubit({required AbstractState seed}) : super(seed);

  void emitNonBuildState() => emit(TestState(1));

  void emitBuildState() => emit(TestBuildState());
}

void main() {
  testWidgets('hook state should be initialized with init state of BlocBase',
      (tester) async {
    late int? stateValue;
    Widget Function(BuildContext) builder(BlocBase<int> cubit) {
      return (context) {
        stateValue = useBlocComparativeBuilder<BlocBase, int>(
          cubit,
          buildWhen: (_, __) => true,
        );
        return Container();
      };
    }

    CounterCubit cubit = CounterCubit(seed: 10);
    await tester.pumpWidget(HookBuilder(builder: builder(cubit)));
    expect(stateValue, 10);

    cubit.increment();
    await tester.pumpWidget(HookBuilder(builder: builder(cubit)));
    expect(stateValue!, 11);
  });

  testWidgets('when BlocBase emits new state, hook state should change',
      (tester) async {
    late int? stateValue;
    Widget Function(BuildContext) builder(BlocBase<int> cubit) {
      return (context) {
        stateValue = useBlocComparativeBuilder<BlocBase, int>(
          cubit,
          buildWhen: (_, __) => true,
        );
        return Container();
      };
    }

    CounterCubit cubit = CounterCubit();
    HookBuilder hookWidget = HookBuilder(builder: builder(cubit));

    await tester.pumpWidget(hookWidget);
    expect(stateValue, 0);
    cubit.increment();
    cubit.increment();
    cubit.increment();
    await tester.pumpWidget(hookWidget);
    expect(stateValue!, 3);
  });

  testWidgets(
      'when Cubit is changed to another instance, new state from new cubit should be emitted',
      (tester) async {
    late TestState? stateValue;
    late int expectedStateHashCode;

    bool useSecond = false;

    Widget Function(BuildContext) builder(
        Cubit<TestState> cubit, Cubit<TestState> cubit2) {
      return (context) {
        final usedCubit = useSecond ? cubit2 : cubit;
        final state = useBlocComparativeBuilder<ComplexCubit, TestState>(
          usedCubit,
          buildWhen: (_, __) => true,
        );
        stateValue = state;
        expectedStateHashCode = state.hashCode;

        return Container();
      };
    }

    TestState testState = TestState(0);
    ComplexCubit complexCubit1 = ComplexCubit(seed: testState);
    ComplexCubit complexCubit2 = ComplexCubit(seed: testState);

    HookBuilder hookWidget = HookBuilder(
      builder: builder(
        complexCubit1,
        complexCubit2,
      ),
    );

    await tester.pumpWidget(Container(child: hookWidget));
    expect(stateValue!.value, 0);
    expect(expectedStateHashCode, testState.hashCode);
    complexCubit1.increment();

    useSecond = true;
    await tester.pump();
    await tester.pumpWidget(Container(child: hookWidget));
    expect(stateValue!.value, 0);
    expect(expectedStateHashCode, testState.hashCode);
  });

  testWidgets('state should not be emitted, when buildWhen returns false',
      (tester) async {
    late TestState? stateValue;

    Widget Function(BuildContext) builder(
      Cubit<TestState> cubit, {
      required bool Function(TestState previous, TestState current) buildWhen,
    }) {
      return (context) {
        stateValue = useBlocComparativeBuilder<ComplexCubit, TestState>(
          cubit,
          buildWhen: (previous, current) => buildWhen(previous, current),
        );
        return Container();
      };
    }

    TestState testState = TestState(3);
    ComplexCubit cubit = ComplexCubit(seed: testState);

    HookBuilder hookWidget = HookBuilder(
      builder: builder(
        cubit,
        buildWhen: (previous, current) => false,
      ),
    );
    pumpIt() async => tester.pumpWidget(hookWidget);

    await pumpIt();
    expect(stateValue!.value, 3);
    cubit.increment();
    await pumpIt();
    expect(stateValue!.value, 3);
    await tester.pump();
  });

  testWidgets('state should be emitted, when buildWhen returns true',
      (tester) async {
    late TestState? stateValue;

    Widget Function(BuildContext) builder(
      Cubit<TestState> cubit, {
      required bool Function(TestState previous, TestState current) buildWhen,
    }) {
      return (context) {
        stateValue = useBlocComparativeBuilder<ComplexCubit, TestState>(
          cubit,
          buildWhen: (previous, current) => buildWhen(previous, current),
        );
        return Container();
      };
    }

    TestState testState = TestState(3);
    ComplexCubit cubit = ComplexCubit(seed: testState);

    HookBuilder hookWidget = HookBuilder(
      builder: builder(
        cubit,
        buildWhen: (previous, current) => true,
      ),
    );
    pumpIt() async => tester.pumpWidget(hookWidget);

    await pumpIt();
    expect(stateValue!.value, 3);
    cubit.increment();
    await pumpIt();
    expect(stateValue!.value, 4);
    await tester.pump();
  });

  testWidgets(
    'buildWhen should not be called with initial value only',
    (tester) async {
      bool checkInvoked = false;
      late TestState? stateValue;

      Widget Function(BuildContext) builder(
        Cubit<TestState> cubit, {
        required bool Function(TestState previous, TestState current) buildWhen,
      }) {
        return (context) {
          stateValue = useBlocComparativeBuilder<ComplexCubit, TestState>(
            cubit,
            buildWhen: (previous, current) {
              checkInvoked = true;
              return buildWhen(previous, current);
            },
          );
          return Container();
        };
      }

      TestState testState = TestState(3);
      ComplexCubit cubit = ComplexCubit(seed: testState);

      HookBuilder hookWidget = HookBuilder(
        builder: builder(
          cubit,
          buildWhen: (previous, current) => true,
        ),
      );

      pumpIt() async => tester.pumpWidget(hookWidget);

      await pumpIt();
      expect(stateValue!.value, 3);
      expect(checkInvoked, false);
    },
  );

  testWidgets(
    'buildWhen should be called for every change to BlocBase',
    (tester) async {
      int checkCounter = 0;
      late TestState? stateValue;

      Widget Function(BuildContext) builder(
        Cubit<TestState> cubit, {
        required bool Function(TestState previous, TestState current) buildWhen,
      }) {
        return (context) {
          stateValue = useBlocComparativeBuilder<ComplexCubit, TestState>(
            cubit,
            buildWhen: (previous, current) {
              checkCounter++;
              return buildWhen(previous, current);
            },
          );
          return Container();
        };
      }

      TestState testState = TestState(3);
      ComplexCubit cubit = ComplexCubit(seed: testState);

      HookBuilder hookWidget = HookBuilder(
        builder: builder(
          cubit,
          buildWhen: (previous, current) => true,
        ),
      );

      pumpIt() async => tester.pumpWidget(hookWidget);

      await pumpIt();
      expect(stateValue!.value, 3);

      cubit.increment();

      await pumpIt();
      expect(checkCounter, 1);
      expect(stateValue!.value, 4);

      cubit.increment();

      await pumpIt();
      expect(checkCounter, 2);
      expect(stateValue!.value, 5);
    },
  );

  testWidgets(
    'buildWhen should be called with previous and current state value',
    (tester) async {
      late int? previousValue;
      late int? currentValue;
      int checkCounter = 0;
      late TestState? stateValue;

      Widget Function(BuildContext) builder(
        Cubit<TestState> cubit, {
        required bool Function(TestState previous, TestState current) buildWhen,
      }) {
        return (context) {
          stateValue = useBlocComparativeBuilder<ComplexCubit, TestState>(
            cubit,
            buildWhen: (previous, current) {
              checkCounter++;
              previousValue = previous.value;
              currentValue = current.value;
              return buildWhen(previous, current);
            },
          );
          return Container();
        };
      }

      TestState testState = TestState(3);
      ComplexCubit cubit = ComplexCubit(seed: testState);

      HookBuilder hookWidget = HookBuilder(
        builder: builder(
          cubit,
          buildWhen: (previous, current) => true,
        ),
      );

      pumpIt() async => tester.pumpWidget(hookWidget);

      await pumpIt();
      expect(stateValue!.value, 3);

      cubit.increment();

      await pumpIt();
      expect(checkCounter, 1);
      expect(previousValue, 3);
      expect(currentValue, 4);
      expect(stateValue!.value, 4);

      cubit.increment();

      await pumpIt();
      expect(checkCounter, 2);
      expect(previousValue, 4);
      expect(currentValue, 5);
      expect(stateValue!.value, 5);
    },
  );
}
