import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:hooked_bloc/src/injection/hook_injection_controller.dart';
import 'package:mocktail/mocktail.dart';

import 'mock.dart';

class MockedCubit extends Mock implements Cubit<int> {}

class TestCubit extends Cubit<int> {
  TestCubit() : super(1);
}

class MockedOnInit extends Mock implements OnInit {}

void main() {
  late Injector injector;

  setUpAll(() {
    registerFallbackValue(TestCubit());
  });

  setUp(() {
    injector = MockedInjector();
    BlocHookInjectionController.initializeWith(() => injector.get);
  });

  testWidgets('should build and close cubit only once', (tester) async {
    final cubit = MockedCubit();
    when(() => injector.get<MockedCubit>()).thenReturn(cubit);
    when(() => cubit.close()).thenAnswer((invocation) => Future.value());

    Future<void> build() async {
      await tester.pumpWidget(HookBuilder(
        builder: (context) {
          useCubit<MockedCubit>();

          return const SizedBox();
        },
      ));
    }

    await build();
    await build();
    await build();
    await tester.pumpWidget(const SizedBox());

    verify(() => injector.get<MockedCubit>()).called(1);
    verify(() => cubit.close()).called(1);
  });

  testWidgets('should build new cubit when keys changes', (tester) async {
    when(() => injector.get<TestCubit>()).thenAnswer((_) => TestCubit());

    late TestCubit generatedCubit;
    Future<void> build(bool param) async {
      await tester.pumpWidget(HookBuilder(
        builder: (context) {
          generatedCubit = useCubit<TestCubit>(keys: [param]);

          return const SizedBox();
        },
      ));
    }

    await build(true);
    final firstCubit = generatedCubit;
    await build(true);
    expect(generatedCubit, firstCubit);
    await build(false);
    expect(generatedCubit, isNot(equals(firstCubit)));
    verify(() => injector.get<TestCubit>()).called(2);
  });

  testWidgets('should call on init for every new instance', (tester) async {
    final onInit = MockedOnInit();
    when(() => onInit.call<TestCubit>(any())).thenAnswer((_) {});
    when(() => injector.get<TestCubit>()).thenAnswer((_) => TestCubit());

    Future<void> build(bool param) async {
      await tester.pumpWidget(HookBuilder(
        builder: (context) {
          useCubit<TestCubit>(keys: [param], onInit: (c) => onInit.call<TestCubit>(c));

          return const SizedBox();
        },
      ));
    }

    await build(true);
    await build(true);
    await build(false);
    verify(() => injector.get<TestCubit>()).called(2);
    verify(() => onInit.call<TestCubit>(any())).called(2);
  });
}
