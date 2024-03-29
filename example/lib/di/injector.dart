import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:example/di/injector.config.dart';

final getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<void> configureDependencies() async => getIt.init();
