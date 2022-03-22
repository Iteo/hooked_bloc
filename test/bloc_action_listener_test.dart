import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

typedef STATE = int;
typedef ACTION = String;

class CounterActionCubit extends ActionCubit<STATE, ACTION> {
  CounterActionCubit({int seed = 0}) : super(seed);

  void increment() {
    emit(state + 1);
  }

  void dispatchAction() {
    dispatch(state.toString());
  }
}

void main() {
  group('Action Listener Hook', () {
    testWidgets('when Cubit emits state, action value should not be changed', (tester) async {
      ACTION? actionValue;

      Widget Function(BuildContext) builder(
        ActionCubit<STATE, ACTION> cubit,
      ) {
        return (context) {
          useActionListener(cubit, (ACTION action) {
            actionValue = action;
          });

          return Container();
        };
      }

      CounterActionCubit cubit = CounterActionCubit();

      HookBuilder hookWidget = HookBuilder(builder: builder(cubit));

      await tester.pumpWidget(hookWidget);
      expect(actionValue, null);

      cubit.increment();
      await tester.pumpWidget(hookWidget);
      expect(actionValue, null);

      cubit.dispatchAction();
      await tester.pumpWidget(hookWidget);
      expect(actionValue, "1");

      cubit.increment();
      cubit.increment();
      await tester.pumpWidget(hookWidget);
      expect(actionValue, "1");
    });

    testWidgets('when Cubit dispatch multiple times the same action, listener should be called multiple times',
        (tester) async {
      int listenerCalls = 0;
      Widget Function(BuildContext) builder(
        ActionCubit<STATE, ACTION> cubit,
      ) {
        return (context) {
          useActionListener(cubit, (ACTION action) {
            listenerCalls++;
          });

          return Container();
        };
      }

      CounterActionCubit cubit = CounterActionCubit();

      HookBuilder hookWidget = HookBuilder(builder: builder(cubit));

      for (int i = 0; i  < 10; i++) {
        cubit.dispatchAction();
        await tester.pumpWidget(hookWidget);
        expect(listenerCalls, i);
      }

    });
  });
}
