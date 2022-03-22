import 'package:flutter_bloc/flutter_bloc.dart' show BlocBase;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/src/cubit_defaults.dart';
import 'package:hooked_bloc/src/injection/hook_injection_controller.dart';

T useCubit<T extends BlocBase>({
  List<dynamic> keys = const <dynamic>[],
  bool closeOnDispose = true,
}) {
  final _injectorFn = BlocHookInjectionController.injector?.call() ??
      CubitDefaults.defaultCubitInjector(useContext());

  final cubit = useMemoized(() => _injectorFn<T>(), keys);

  useEffect(() {
    return closeOnDispose ? cubit.close : null;
  }, [cubit]);

  return cubit;
}
