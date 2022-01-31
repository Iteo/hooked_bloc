typedef CubitInjector = T Function<T extends Object>();
typedef CubitInjectionFunction = CubitInjector Function();

class BlocHookInjectionController {
  static CubitInjectionFunction? _injector;

  static void initializeWith<T>(CubitInjectionFunction injector) {
    BlocHookInjectionController._injector = injector;
  }

  static  CubitInjectionFunction? get injector => _injector;
}
