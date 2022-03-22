import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:hooked_bloc/src/cubit_defaults.dart';

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
  testWidgets('hook state should be initialized with init state of BlocBase', (tester) async {
    late int? stateValue;
    Widget Function(BuildContext) builder(BlocBase<int> cubit) {
      return (context) {
        stateValue = useCubitBuilder<BlocBase, int>(cubit);
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

  testWidgets('when BlocBase emits new state, hook state should change', (tester) async {
    late int? stateValue;
    Widget Function(BuildContext) builder(BlocBase<int> cubit) {
      return (context) {
        stateValue = useCubitBuilder<BlocBase, int>(cubit);
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

  testWidgets('when Cubit is changed to another instance, new state from new cubit should be emitted', (tester) async {
    late TestState? stateValue;
    late int expectedStateHashCode;

    bool useSecond = false;

    Widget Function(BuildContext) builder(Cubit<TestState> cubit, Cubit<TestState> cubit2) {
      return (context) {
        final usedCubit = useSecond ? cubit2 : cubit;
        final state = useCubitBuilder<ComplexCubit, TestState>(usedCubit);
        stateValue = state;
        expectedStateHashCode = state.hashCode;

        return Container();
      };
    }

    TestState testState = TestState(0);
    ComplexCubit complexCubit1 = ComplexCubit(seed: testState);
    ComplexCubit complexCubit2 = ComplexCubit(seed: testState);

    HookBuilder hookWidget = HookBuilder(builder: builder(complexCubit1, complexCubit2));

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

  testWidgets('when Cubit is changed to another instance, new state from new cubit should be emitted', (tester) async {
    late TestState? stateValue;
    late int expectedStateHashCode;

    bool useSecond = false;

    Widget Function(BuildContext) builder(Cubit<TestState> cubit, Cubit<TestState> cubit2) {
      return (context) {
        final usedCubit = useSecond ? cubit2 : cubit;
        final state = useCubitBuilder<ComplexCubit, TestState>(usedCubit);
        stateValue = state;
        expectedStateHashCode = state.hashCode;

        return Container();
      };
    }

    TestState testState = TestState(0);
    ComplexCubit complexCubit1 = ComplexCubit(seed: testState);
    ComplexCubit complexCubit2 = ComplexCubit(seed: testState);

    HookBuilder hookWidget = HookBuilder(builder: builder(complexCubit1, complexCubit2));

    await tester.pumpWidget(hookWidget);
    expect(stateValue!.value, 0);
    expect(expectedStateHashCode, testState.hashCode);
    complexCubit1.increment();

    useSecond = true;
    await tester.pump();
    await tester.pumpWidget(hookWidget);
    expect(stateValue!.value, 0);
    expect(expectedStateHashCode, testState.hashCode);
  });

  testWidgets('state should not be emitted, when buildWhen specified', (tester) async {
    late TestState? stateValue;

    Widget Function(BuildContext) builder(
      Cubit<TestState> cubit, {
      required bool Function(TestState state) buildWhen,
    }) {
      return (context) {
        stateValue = useCubitBuilder<ComplexCubit, TestState>(cubit, buildWhen: buildWhen);
        return Container();
      };
    }

    TestState testState = TestState(3);
    ComplexCubit cubit = ComplexCubit(seed: testState);
    List<int> valuesNotPermitted = [5, 6];

    HookBuilder hookWidget =
        HookBuilder(builder: builder(cubit, buildWhen: (TestState state) => !valuesNotPermitted.contains(state.value)));
    pumpIt() async => tester.pumpWidget(hookWidget);

    await pumpIt();
    expect(stateValue!.value, 3);
    cubit.increment();
    await pumpIt();
    expect(stateValue!.value, 4);
    await tester.pump();

    cubit.increment(); //5 - not emitted
    await pumpIt();
    expect(stateValue!.value, 4);

    cubit.increment(); //6 - not emitted
    await pumpIt();
    expect(stateValue!.value, 4);

    cubit.increment(); //7 - emitted
    await pumpIt();
    expect(stateValue!.value, 7);
  });

  testWidgets('state should be emitted when state is BuildState', (tester) async {
    late AbstractState? stateValue;

    Widget Function(BuildContext) builder(AbstractStateCubit cubit) {
      return (context) {
        stateValue = useCubitBuilder<AbstractStateCubit, AbstractState>(cubit,
            buildWhen: CubitDefaults.passOnlyBuildStateCondition);
        return Container();
      };
    }

    AbstractState testState = TestState(0);
    AbstractStateCubit cubit = AbstractStateCubit(seed: testState);

    HookBuilder hookWidget = HookBuilder(builder: builder(cubit));
    await tester.pumpWidget(Container(child: hookWidget));
    expect(stateValue, isA<TestState>());

    cubit.emitNonBuildState();
    await tester.pumpWidget(Container(child: hookWidget));
    expect(stateValue, isA<TestState>());

    cubit.emitBuildState();
    await tester.pumpWidget(Container(child: hookWidget));
    expect(stateValue, isA<TestBuildState>());

    cubit.emitBuildState();
    await tester.pumpWidget(hookWidget);
    cubit.emitNonBuildState();
    await tester.pumpWidget(hookWidget);
    cubit.emitNonBuildState();
    await tester.pumpWidget(hookWidget);
    cubit.emitNonBuildState();
    await tester.pumpWidget(hookWidget);

    expect(stateValue, isA<TestBuildState>());
  });
}
