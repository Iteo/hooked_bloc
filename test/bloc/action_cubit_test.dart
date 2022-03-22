import 'package:flutter_test/flutter_test.dart';
import 'package:hooked_bloc/src/bloc/action_cubit.dart';

class TestActionCubit extends ActionCubit<int, String> {
  TestActionCubit() : super(-1);
  void pushAction(int action) => dispatch(action.toString());
}

void main() {
  late TestActionCubit testActionCubit;

  setUp(() {
    testActionCubit = TestActionCubit();
  });

  test('Action cubit should emit added actions', () {
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

    expectLater(testActionCubit.actions, emitsInOrder(expected));

    actions.forEach(testActionCubit.pushAction);
  });
}
