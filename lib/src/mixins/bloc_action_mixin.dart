/// credits: Dawid Krysiński and Mateusz Ledwoń
library;

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:meta/meta.dart';

/// General purpose mixin on [BlocBase]. Provides new method [BlocActionMixin.dispatch], to emit new action event.
///
/// Adds new stream with elements of type [ACTION], independent of o Bloc state.
/// It can be useful, when widget should react on "Actions" like showing popups, toast, navigation etc.
/// Emitted actions does not affect widget itself.
///
/// [BlocActionMixin] is easy to use and connect to existing [BlocBase] classes. Simply:
/// ```dart
/// class MessageActionCubit extends Cubit<BuildState> with BlocActionMixin<String, BuildState> {
///   ...
/// }
/// ```
///
/// Handling actions on the widget side, is simple. Just use [useActionListener], like so:
/// ```dart
///  @override
///   Widget build(BuildContext context) {
///     // Handle separate action stream with values other than a state type
///     useActionListener(cubit, (String action) {
///        //do sth with action
///       _showMessage(context, action);
///     });
///    ...
///   }
/// ```
///
/// You can also filter your actions using actionWhen.
/// ```dart
///     useActionListener(
///       cubit,
///       (String action) {
///         //do sth with filtered action
///         _showMessage(context, action);
///       },
///       actionWhen: (previousAction, action) => true,
///     });
/// ```
/// See also [ActionCubit] and [ActionBloc]
mixin BlocActionMixin<ACTION, S> on BlocBase<S> {
  final _streamController = StreamController<ACTION>.broadcast();

  ACTION? previousAction;

  Stream<ACTION> get actions => _streamController.stream;

  @visibleForTesting
  StreamController<ACTION> get actionStreamController => _streamController;

  @protected
  void dispatch(ACTION action) {
    _streamController.add(action);
    previousAction = action;
  }

  @override
  bool get isClosed => super.isClosed || _streamController.isClosed;

  @override
  Future<void> close() async {
    previousAction = null;
    await Future.wait([
      super.close(),
      _streamController.close(),
    ]);
  }
}
