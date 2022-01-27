import 'package:flutter_bloc/flutter_bloc.dart' show BlocBase;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/src/cubit_defaults.dart';
import 'package:hooked_bloc/src/injection/hook_injection_controller.dart';

typedef CubitInitCommand<T extends BlocBase> = void Function(T cubit);

T useCubit<T extends BlocBase>({
  List<dynamic> keys = const <dynamic>[],
  CubitInitCommand<T>? onInit,
}) {
  final _injectorFn = BlocHookInjectionController.injector?.call() ??
      CubitDefaults.defaultCubitInjector(useContext());

  final cubit = useMemoized(() => _injectorFn<T>(), keys);

  useEffect(() {
    onInit?.call(cubit);
    return cubit.close;
  }, [cubit]);

  return cubit;
}
