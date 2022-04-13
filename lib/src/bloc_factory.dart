import 'package:flutter_bloc/flutter_bloc.dart' show BlocBase;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/src/cubit_defaults.dart';
import 'package:hooked_bloc/src/injection/hook_injection_controller.dart';

abstract class BlocFactory<T extends BlocBase> {
  T create();
}

typedef OnBlocCreated<F extends BlocFactory> = Function(F factory);

/// Creates BlocBase<T> class using provided factory.
///
/// [useCubitFactory] will find [BlocFactory] class using injector provided by [BlocHookInjectionController] and then return [BlocBase] created by it.
/// If [BlocHookInjectionController] has no provided injectors, [useCubitFactory] will look into widget tree and try find [BlocFactory] using [Provider.of] method
///
/// By using [onCubitCreate] callback you can configure factory before creating desired [BlocBase]
///
/// [useCubitFactory] will call automatically [BlocBase.close] method. If needed, this behaviour can be changed by setting [closeOnDispose] flag to false
T useCubitFactory<T extends BlocBase, F extends BlocFactory<T>>({
  OnBlocCreated<F>? onCubitCreate,
  List<dynamic> keys = const <dynamic>[],
  bool closeOnDispose = true,
}) {
  final _injectorFn = BlocHookInjectionController.injector?.call() ??
      CubitDefaults.defaultCubitInjector(useContext());

  final blocFactory = useMemoized(() => _injectorFn<F>(), keys);
  final cubit = useMemoized(
    () {
      onCubitCreate?.call(blocFactory);
      return blocFactory.create();
    },
    [blocFactory, ...keys],
  );

  useEffect(() {
    return closeOnDispose ? cubit.close : null;
  }, [cubit]);

  return cubit;
}
