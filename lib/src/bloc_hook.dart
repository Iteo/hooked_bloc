import 'package:flutter_bloc/flutter_bloc.dart' show BlocBase;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/src/cubit_defaults.dart';
import 'package:hooked_bloc/src/injection/bloc_hook_injector_config.dart';
import 'package:hooked_bloc/src/injection/hook_injection_controller.dart';

/// Provides BlocBase<T> class.
///
/// [useCubit] will find and return [BlocBase] class using injector provided by [BlocHookInjectionController]
/// If [BlocHookInjectionController] has no provided injectors, [useCubit] will look into widget tree and try find BlocBase using [BlocProvider]
///
/// [useCubit] will call automatically [BlocBase.close] method. If needed, this behaviour can be changed by setting [closeOnDispose] flag to false
T useCubit<T extends BlocBase>({
  List<dynamic> keys = const <dynamic>[],
  bool closeOnDispose = true,
}) {
  final context = useContext();
  final configuredInjector = useBlocHookInjectorConfig().injector;
  final injector =
      configuredInjector?.call() ?? CubitDefaults.defaultCubitInjector(context);

  final cubit = useMemoized(() => injector<T>(), keys);

  useEffect(
    () {
      return closeOnDispose ? cubit.close : null;
    },
    [cubit],
  );

  return cubit;
}
