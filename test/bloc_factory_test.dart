import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:hooked_bloc/src/injection/hook_injection_controller.dart';
import 'package:mocktail/mocktail.dart';

import 'mock.dart';

class MockedCubit extends Mock implements Cubit<int> {}

class MockedCubitFactory extends Mock implements BlocFactory<MockedCubit> {
  void config();
}

class TestCubit extends Cubit<int> {
  TestCubit() : super(1);
}

class TestCubitFactory extends BlocFactory<TestCubit> {
  @override
  TestCubit create() => TestCubit();
}

class MockedOnInit extends Mock implements OnInit {}

void main() {
  setUpAll(() {
    registerFallbackValue(TestCubit());
  });

  group('Tests with mockedInjector', () {
    late Injector injector;
    setUp(() {
      injector = MockedInjector();
      HookedBloc.initialize(() => injector.get);
    });

    tearDown(() {
      BlocHookInjectionController.cleanUp();
    });

    testWidgets('should build and close cubit only once', (tester) async {
      final cubit = MockedCubit();
      final cubitFactory = MockedCubitFactory();
      when(() => injector.get<MockedCubitFactory>()).thenReturn(cubitFactory);
      when(() => cubitFactory.create()).thenReturn(cubit);
      when(() => cubit.close()).thenAnswer((invocation) => Future.value());

      Future<void> build() async {
        await tester.pumpWidget(HookBuilder(
          builder: (context) {
            useCubitFactory<MockedCubit, MockedCubitFactory>();

            return const SizedBox();
          },
        ));
      }

      await build();
      await build();
      await build();
      await tester.pumpWidget(const SizedBox());

      verify(() => injector.get<MockedCubitFactory>()).called(1);
      verify(() => cubit.close()).called(1);
    });

    testWidgets('should build only once and do not close cubit',
        (tester) async {
      final cubit = MockedCubit();
      final cubitFactory = MockedCubitFactory();
      when(() => injector.get<MockedCubitFactory>()).thenReturn(cubitFactory);
      when(() => cubitFactory.create()).thenReturn(cubit);
      when(() => cubit.close()).thenAnswer((invocation) => Future.value());

      Future<void> build() async {
        await tester.pumpWidget(HookBuilder(
          builder: (context) {
            useCubitFactory<MockedCubit, MockedCubitFactory>(
                closeOnDispose: false);

            return const SizedBox();
          },
        ));
      }

      await build();
      await build();
      await build();
      await tester.pumpWidget(const SizedBox());

      verify(() => injector.get<MockedCubitFactory>()).called(1);
      verifyNever(() => cubit.close());
    });

    testWidgets('should call onCubitCreate on every new cubit instance',
        (tester) async {
      final cubitFactory = MockedCubitFactory();
      when(() => injector.get<MockedCubitFactory>()).thenReturn(cubitFactory);
      when(() => cubitFactory.create()).thenAnswer((invocation) {
        final cubit = MockedCubit();
        when(() => cubit.close()).thenAnswer((invocation) async {});
        return cubit;
      });

      Future<void> build(dynamic param) async {
        await tester.pumpWidget(HookBuilder(
          builder: (context) {
            useCubitFactory<MockedCubit, MockedCubitFactory>(
              onCubitCreate: (factory) {
                factory.config();
              },
              keys: [param],
            );

            return const SizedBox();
          },
        ));
      }

      await build(0);
      await build(1);
      await build(2);
      await tester.pumpWidget(const SizedBox());

      verify(() => injector.get<MockedCubitFactory>()).called(3);
      verify(() => cubitFactory.create()).called(3);
      verify(() => cubitFactory.config()).called(3);
    });

    testWidgets('should build new cubit when keys changes', (tester) async {
      when(() => injector.get<TestCubitFactory>())
          .thenAnswer((_) => TestCubitFactory());

      late TestCubit generatedCubit;
      Future<void> build(bool param) async {
        await tester.pumpWidget(HookBuilder(
          builder: (context) {
            generatedCubit = useCubitFactory<TestCubit, TestCubitFactory>(
              keys: [param],
            );

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
      verify(() => injector.get<TestCubitFactory>()).called(2);
    });

    testWidgets('should call on init for every new instance', (tester) async {
      when(() => injector.get<TestCubitFactory>())
          .thenAnswer((_) => TestCubitFactory());

      Future<void> build(bool param) async {
        await tester.pumpWidget(HookBuilder(
          builder: (context) {
            useCubitFactory<TestCubit, TestCubitFactory>(keys: [param]);
            return const SizedBox();
          },
        ));
      }

      await build(true);
      await build(true);
      await build(false);
      verify(() => injector.get<TestCubitFactory>()).called(2);
    });
  });

  group('Tests with default injector', () {
    testWidgets('Should find proper BlocFactory from widget tree',
        (tester) async {
      final onInit = MockedOnInit();
      when(() => onInit.call<TestCubit>(any())).thenAnswer((_) {});

      Future<void> build() async {
        await tester.pumpWidget(
          Provider.value(
            value: TestCubitFactory(),
            child: HookBuilder(
              builder: (context) {
                final cubit = useCubitFactory<TestCubit, TestCubitFactory>();

                useEffect(() {
                  onInit.call<TestCubit>(cubit);
                  return cubit.close;
                }, [cubit]);

                return const SizedBox();
              },
            ),
          ),
        );
      }

      await build();
      verify(() => onInit.call<TestCubit>(any())).called(1);
    });
  });
}
