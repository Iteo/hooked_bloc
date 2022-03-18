import 'package:example/cubit/real_life_cubit.dart';
import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart' as hooked;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/clickable_item_list.dart';
import '../widget/item_detail_dialog.dart';

class RealLifePage extends StatelessWidget {
  const RealLifePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Real life example")),
      body: BlocProvider<RealLifeCubit>(
        create: (context) => RealLifeCubit(),
        child: BlocListener<RealLifeCubit, hooked.BuildState>(
          listenWhen: (_, state) => state is ErrorState,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text((state as ErrorState).error)),
            );
          },
          child: BlocBuilder<RealLifeCubit, hooked.BuildState>(
            buildWhen: (_, state) => [LoadedState, LoadingState, ShowItemState]
                .contains(state.runtimeType),
            builder: (BuildContext context, hooked.BuildState state) {
              BlocProvider.of<RealLifeCubit>(context).loadData();
              switch (state.runtimeType) {
                case LoadedState:
                  return ClickableItemList(
                    data: (state as LoadedState).data,
                    itemCallback: (index) =>
                        BlocProvider.of<RealLifeCubit>(context).goToItem(index),
                  );
                case ShowItemState:
                  return ItemDetailDialog(index: (state as ShowItemState).index);
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}