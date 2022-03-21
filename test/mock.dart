import 'package:mocktail/mocktail.dart';

abstract class Injector {
  T get<T extends Object>();
}

class MockedInjector extends Mock implements Injector {}

abstract class OnInit {
  void call<T>(T param);
}
