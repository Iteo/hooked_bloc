import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:hooked_bloc/src/injection/bloc_hook_injector_config.dart';

class CubitDefaults {
  static bool alwaysListenCondition<S>(S state) => true;

  static bool alwaysRebuildCondition<S>(S state) => true;

  static bool passOnlyBuildStateCondition<S>(S state) => state is BuildState;

  static CubitInjector defaultCubitInjector(BuildContext context) {
    return <T extends Object>() => context.read<T>();
  }
}
