import 'package:example/widget/fab_actions_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../cubit/action_cubit.dart';
import '../cubit/event_cubit.dart';
import '../widget/message_bottom_sheet_content.dart';

// The page must inherit from HookWidget
class UseActionListenerPage extends HookWidget {
  UseActionListenerPage({Key? key}) : super(key: key);

  final MessageActionCubit cubit = MessageActionCubit();

  @override
  Widget build(BuildContext context) {
    // Handle separate action stream with values other than a state type
    useActionListener(cubit, (String action) {
      _showMessage(context, action);
    });

    final state = useCubitBuilder(cubit, buildWhen: (st) => st is UpdateScreen);
    // Because of the buildWhen, we are sure about state type
    final count = (state as UpdateScreen).counter;

    return FabActionsScaffold(
      title: "useActionListener",
      count: count,
      incrementCallback: () => cubit.increment(),
      messageCallback: (message) => cubit.dispatch(message),
    );
  }

  void _showMessage(BuildContext context, String? message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => MessageBottomSheetContent(message: message),
    );
  }
}
