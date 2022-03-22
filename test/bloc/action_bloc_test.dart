import 'package:flutter_test/flutter_test.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

class TestActionBloc extends ActionBloc<int, int, String> {
  TestActionBloc() : super(-1);

  void pushAction(int action) => dispatch(action.toString());
}

void main() {
  late TestActionBloc testActionBloc;

  setUp(() {
    testActionBloc = TestActionBloc();
  });

  test('Action bloc should emit added actions', () {
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

    expectLater(testActionBloc.actions, emitsInOrder(expected));

    actions.forEach(testActionBloc.pushAction);
  });
}
