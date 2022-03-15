import 'package:example/presentation/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return CounterCubit("Provider");
      },
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends HookWidget {
  const _HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CounterCubit cubit = useCubit<CounterCubit>(onInit: (cubit) => cubit.init());

    final data = useState(0);

    useEffect(() {
      data.value = cubit.hashCode;

      () async {
        Future.delayed(const Duration(seconds: 2));
        data.value = cubit.hashCode;
      }();
    }, [cubit]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(data.value.toString()),
      ),
    );
  }
}
