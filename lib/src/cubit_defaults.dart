import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBase, ReadContext;
import 'package:hooked_bloc/hooked_bloc.dart';

class CubitDefaults {
  static bool defaultBlocListenCondition<S>(S state) => true;

  static bool defaultBlocBuilderCondition<S>(S state) => state is BuildState;

  static  CubitInjector defaultCubitInjector(BuildContext context) {
    return  <T extends Object>() => context.read<T>() ;
  }

}
