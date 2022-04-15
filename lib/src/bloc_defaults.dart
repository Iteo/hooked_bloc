import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:hooked_bloc/src/config/hooked_bloc_config.dart';

class BlocDefaults {
  static bool alwaysListenCondition<S>(S state) => true;

  static bool alwaysRebuildCondition<S>(S state) => true;

  static bool passOnlyBuildStateCondition<S>(S state) => state is BuildState;

  static BlocInjector defaultBlocInjector(BuildContext context) {
    return <T extends Object>() => context.read<T>();
  }
}
