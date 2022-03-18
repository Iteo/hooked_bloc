import 'package:example/cubit/real_life_cubit.dart';
import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../widget/clickable_item_list.dart';
import '../widget/item_detail_dialog.dart';

class RealLifeHookPage extends HookWidget {
  const RealLifeHookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<RealLifeCubit>();

    useCubitListener<RealLifeCubit, BuildState>(cubit, (cubit, value, context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text((value as ErrorState).error)),
      );
    }, listenWhen: (state) => state is ErrorState);

    final state = useCubitBuilder(
      cubit,
      buildWhen: (state) => [LoadedState, LoadingState, ShowItemState].contains(
        state.runtimeType,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Real life example with hooks")),
      body: Builder(builder: (_) {
        switch (state.runtimeType) {
          case LoadedState:
            return ClickableItemList(
              data: (state as LoadedState).data,
              itemCallback: (index) => cubit.goToItem(index),
            );
          case ShowItemState:
            return ItemDetailDialog(index: (state as ShowItemState).index);
          default:
            cubit.loadData();
            return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}
