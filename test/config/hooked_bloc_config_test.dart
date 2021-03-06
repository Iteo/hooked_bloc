import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooked_bloc/src/bloc_defaults.dart';
import 'package:hooked_bloc/src/config/hooked_bloc_config.dart';
import 'package:hooked_bloc/src/hooked_bloc.dart';

void main() {
  testWidgets(
    'config matches default values when nothing was passed',
    (tester) async {
      late HookedBlocConfig config;

      await tester.pumpWidget(
        HookedBlocConfigProvider(
          child: HookBuilder(
            builder: (context) {
              config = useHookedBlocConfig();
              return Container();
            },
          ),
        ),
      );

      expect(config.injector, null);
      expect(config.builderCondition,
          BlocDefaults.alwaysRebuildCondition<dynamic>);
      expect(config.listenerCondition,
          BlocDefaults.alwaysListenCondition<dynamic>);
    },
  );

  testWidgets(
    'config matches passed values',
    (tester) async {
      T objectFactory<T extends Object>() => throw Exception();
      BlocInjector injector() => objectFactory;
      bool builderCondition(state) => true;
      bool listenerCondition(state) => true;

      late HookedBlocConfig config;

      await tester.pumpWidget(
        HookedBlocConfigProvider(
          injector: injector,
          builderCondition: builderCondition,
          listenerCondition: listenerCondition,
          child: HookBuilder(
            builder: (context) {
              config = useHookedBlocConfig();
              return Container();
            },
          ),
        ),
      );

      expect(config.injector, injector);
      expect(config.builderCondition, builderCondition);
      expect(config.listenerCondition, listenerCondition);
    },
  );
}
