import 'package:flutter_bloc/flutter_bloc.dart' show BlocBase;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/src/bloc_defaults.dart';
import 'package:hooked_bloc/src/config/hooked_bloc_config.dart';

/// Provides [BlocBase<T>] class.
///
/// [useBloc] will find and return [BlocBase] class using injector provided by [BlocHookInjectionController]
/// If [BlocHookInjectionController] has no provided injectors, [useBloc] will look into widget tree and try find BlocBase using [BlocProvider]
///
/// [useBloc] will call automatically [BlocBase.close] method. If needed, this behaviour can be changed by setting [closeOnDispose] flag to false
T useBloc<T extends BlocBase>({
  List<dynamic> keys = const <dynamic>[],
  bool closeOnDispose = true,
}) {
  final context = useContext();
  final configuredInjector = useHookedBlocConfig().injector;
  final injector =
      configuredInjector?.call() ?? BlocDefaults.defaultBlocInjector(context);

  final bloc = useMemoized(() => injector<T>(), keys);

  useEffect(
    () {
      return closeOnDispose ? bloc.close : null;
    },
    [bloc],
  );

  return bloc;
}
