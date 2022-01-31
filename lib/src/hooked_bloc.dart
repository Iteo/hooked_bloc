import 'package:hooked_bloc/src/injection/hook_injection_controller.dart';

class HookedBloc {
  static void initialize(CubitInjectionFunction injectionFunction) {
    BlocHookInjectionController.initializeWith(injectionFunction);
  }
}
