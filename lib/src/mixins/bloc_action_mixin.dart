/// credits: Dawid Krysiński and Mateusz Ledwoń

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

mixin BlocActionMixin<ACTION, S extends Object> on BlocBase<S> {
  final _streamController = StreamController<ACTION>.broadcast();

  Stream<ACTION> get actions => _streamController.stream;

  @visibleForTesting
  StreamController<ACTION> get actionStreamController => _streamController;

  @protected
  void dispatch(ACTION action) {
    _streamController.add(action);
  }

  @override
  Future<void> close() async {
    super.close();
    _streamController.close();
  }
}
