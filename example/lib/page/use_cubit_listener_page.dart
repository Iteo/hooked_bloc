import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../cubit/event_cubit.dart';
import '../widget/fab_actions_scaffold.dart';
import '../widget/message_bottom_sheet_content.dart';

class UseCubitListenerPage extends HookWidget {
  UseCubitListenerPage({Key? key}) : super(key: key);

  final EventCubit cubit = EventCubit();

  @override
  Widget build(BuildContext context) {
    // Handle state as event independently of the view state
    useCubitListener(cubit, (_, value, context) {
      _showMessage(context, (value as ShowMessage).message);
    }, listenWhen: (state) => state is ShowMessage);

    final state = useCubitBuilder(
      cubit,
      buildWhen: (st) => st is UpdateScreen,
    );
    // Because of the buildWhen, we are sure about state type
    final count = (state as UpdateScreen).counter;

    return FabActionsScaffold(
      title: "useCubitListener",
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
