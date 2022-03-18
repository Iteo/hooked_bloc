import 'package:example/cubit/real_life_cubit.dart';
import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart' as hooked;
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  return _ClickableItemList(
                    data: (state as LoadedState).data,
                    itemCallback: (index) =>
                        BlocProvider.of<RealLifeCubit>(context).goToItem(index),
                  );
                case ShowItemState:
                  return _DetailDialog(index: (state as ShowItemState).index);
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

class _DetailDialog extends StatelessWidget {
  const _DetailDialog({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Item $index"),
      content: const Text("Now you can see the details of item"),
    );
  }
}

class _ClickableItemList extends StatelessWidget {
  const _ClickableItemList({
    Key? key,
    required this.itemCallback,
    required this.data,
  }) : super(key: key);

  final Function(int) itemCallback;
  final List<String> data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...data.map((item) => ListTile(
              onTap: () => itemCallback(data.indexOf(item)),
              title: Text(item),
            ))
      ],
    );
  }
}
