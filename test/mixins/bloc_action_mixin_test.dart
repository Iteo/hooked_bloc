import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

class TestCubitWithMixin extends Cubit<int> with BlocActionMixin<String, int> {
  TestCubitWithMixin() : super(-1);

  void pushAction(int action) => dispatch(action.toString());
}

void main() {
  late TestCubitWithMixin testCubit;

  setUp(() {
    testCubit = TestCubitWithMixin();
  });

  test('test cubit with mixin should emit added actions', () {
    const actions = [1, 2, 3, 454, 5, 6, 6, 3, 3, 5, 32, 234, 452, 3243, 324, 233, 3];
    final expected = actions.map((e) => e.toString()).toList();

    expectLater(testCubit.actions, emitsInOrder(expected));

    actions.forEach(testCubit.pushAction);

  });
}
