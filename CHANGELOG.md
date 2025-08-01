## 1.7.0

- Updated flutter_hooks to support ^0.21.0 version

## 1.6.0

- Updated flutter_bloc to 9.0.0 and other dependencies
- Fix `isClosed` bad status (see
  [#87](https://github.com/Iteo/hooked_bloc/issues/87), thanks to @westito)
- Updated example dependencies

## 1.5.0

- Allow filter actions in Bloc using actionWhen in useActionListener

## 1.4.4

- Allow put void type to generic type
- Updated dependencies

## 1.4.3

- Updated dependencies

## 1.4.2

- Fix the unclosing bloc listeners after widget dispose (see
  [#70](https://github.com/Iteo/hooked_bloc/issues/70), thanks to @ruslic19)

## 1.4.1

- Replaced outdated documentation link with a valid one

## 1.4.0

- Added new useBlocComparativeListener
- Added useBlocComparativeListener example

## 1.3.0

- Added new useBlocComparativeBuilder
- Updated and corrected examples

## 1.2.1

- Await closing actions stream

## 1.2.0

- Updated to flutter 3.0

## 1.1.0

[Breaking Changes]

- renamed all "cubit" related methods name to "bloc" based naming
- Replaced `HookedBloc.initialize` global initializer with new
  `HookedBlocConfigProvider` widget

## 1.0.4

- Added new useCubitFactory hook

## 1.0.3

- Fixed bug useCubitBuilder hook. Since 1.0.2 every change in cubit/bloc state
  generated new stream.

## 1.0.2

- Added missing code documentation.

## 1.0.1

- Fix logo link.

## 1.0.0

- Initial release.
