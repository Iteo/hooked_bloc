import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../mock.dart';

class TestCubitWithMixin extends Cubit<int> with BlocActionMixin<String, int> {
  TestCubitWithMixin() : super(-1);

  void pushAction(int action) => dispatch(action.toString());
}

void main() {
  late TestCubitWithMixin testCubit;
  late Injector injector;

  setUp(() {
    injector = MockedInjector();
    testCubit = TestCubitWithMixin();
  });

  test('test cubit with mixin should emit added actions', () {
    const actions = [
      1,
      2,
      3,
      454,
      5,
      6,
      6,
      3,
      3,
      5,
      32,
      234,
      452,
      3243,
      324,
      233,
      3
    ];
    final expected = actions.map((e) => e.toString()).toList();

    expectLater(testCubit.actions, emitsInOrder(expected));

    actions.forEach(testCubit.pushAction);
  });

  testWidgets('should close actions stream controller, when cubit closed',
      (tester) async {
    final cubit = TestCubitWithMixin();
    when(() => injector.get<TestCubitWithMixin>()).thenReturn(cubit);

    Future<void> build() async {
      await tester.pumpWidget(
        HookedBlocConfigProvider(
          injector: () => injector.get,
          child: HookBuilder(
            builder: (context) {
              useCubit<TestCubitWithMixin>();

              return const SizedBox();
            },
          ),
        ),
      );
    }

    await build();
    await tester.pumpWidget(const SizedBox());

    expect(true, cubit.actionStreamController.isClosed);
    expect(true, cubit.isClosed);
  });
}
