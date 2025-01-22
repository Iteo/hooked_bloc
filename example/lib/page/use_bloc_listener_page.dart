import 'package:example/cubit/event_cubit.dart';
import 'package:example/widget/fab_actions_scaffold.dart';
import 'package:example/widget/message_bottom_sheet_content.dart';
import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UseBlocListenerPage extends HookWidget {
  UseBlocListenerPage({super.key});

  final EventCubit cubit = EventCubit();

  @override
  Widget build(BuildContext context) {
    // Handle state as event independently of the view state
    useBlocListener(cubit, (_, value, context) {
      _showMessage(context, (value as ShowMessage).message);
    }, listenWhen: (state) => state is ShowMessage);

    final state = useBlocBuilder(
      cubit,
      buildWhen: (st) => st is UpdateScreen,
    );
    // Because of the buildWhen, we are sure about state type
    final count = (state as UpdateScreen).counter;

    return FabActionsScaffold(
      title: "useBlocListener",
      count: count,
      incrementCallback: () => cubit.increment(),
      messageCallback: (message) => cubit.showMessage(message),
    );
  }

  void _showMessage(BuildContext context, String? message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => MessageBottomSheetContent(message: message),
    );
  }
}
