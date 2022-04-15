import 'package:flutter_bloc/flutter_bloc.dart' show BlocBase;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/src/bloc_defaults.dart';
import 'package:hooked_bloc/src/config/hooked_bloc_config.dart';

abstract class BlocFactory<T extends BlocBase> {
  T create();
}

typedef OnBlocCreated<F extends BlocFactory> = Function(F factory);

/// Creates BlocBase<T> class using provided factory.
///
/// [useBlocFactory] will find [BlocFactory] class using injector provided by [BlocHookInjectionController] and then return [BlocBase] created by it.
/// If [BlocHookInjectionController] has no provided injectors, [useBlocFactory] will look into widget tree and try find [BlocFactory] using [Provider.of] method
///
/// By using [onCubitCreate] callback you can configure factory before creating desired [BlocBase]
///
/// [useBlocFactory] will call automatically [BlocBase.close] method. If needed, this behaviour can be changed by setting [closeOnDispose] flag to false
T useBlocFactory<T extends BlocBase, F extends BlocFactory<T>>({
  OnBlocCreated<F>? onBlocCreate,
  List<dynamic> keys = const <dynamic>[],
  bool closeOnDispose = true,
}) {
  final context = useContext();
  final configuredInjector = useHookedBlocConfig().injector;
  final injector =
      configuredInjector?.call() ?? BlocDefaults.defaultBlocInjector(context);

  final blocFactory = useMemoized(() => injector<F>(), keys);
  final bloc = useMemoized(
    () {
      onBlocCreate?.call(blocFactory);
      return blocFactory.create();
    },
    [blocFactory, ...keys],
  );

  useEffect(() {
    return closeOnDispose ? bloc.close : null;
  }, [bloc]);

  return bloc;
}
