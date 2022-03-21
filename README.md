<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

<p align="center">
<img src="https://raw.githubusercontent.com/rrousselGit/flutter_hooks/master/packages/flutter_hooks/flutter-hook.svg?sanitize=true" width="110">
</p>

# Hooked Bloc

Flutter package that simplifies injection and usage of <a href="https://pub.dev/packages/flutter_bloc"> Bloc/Cubit</a>.
The library is based on the concept of hooks originally introduced in React Native and adapted to Flutter.
<a href="https://github.com/rrousselGit/flutter_hooks">Flutter hooks</a> allow you to extract view's logic
into common use cases and reuse them, what makes writing widgets faster and easier.

## Motivation

When you want to use Bloc/Cubit in your application
you have to provide an instance of object down the widgets tree for state receivers.
This is mostly achieved by `BlocBuilder` along with `BlocProvider` and enlarges
complexity of the given widget.

Each time you have to use `BlocBuilder`, `BlocListener` or `BlocSelector`. What if we can use a power of Flutter hooks?


So, instead of this:
```dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ...,
      body: BlocProvider<RealLifeCubit>(
        create: (context) => RealLifeCubit()..loadData(),
        child: BlocListener<RealLifeCubit, hooked.BuildState>(
          listenWhen: (_, state) => state is ErrorState,
          listener: (context, state) {
            // Show some view on event
          },
          child: BlocBuilder<RealLifeCubit, hooked.BuildState>(
            buildWhen: (_, state) => [LoadedState, LoadingState, ShowItemState]
                .contains(state.runtimeType),
            builder: (BuildContext context, hooked.BuildState state) {
              return // Build your widget using `state`
            },
          ),
        ),
      ),
    );
  }

```

We can have this:

```dart
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<RealLifeCubit>();

    useCubitListener<RealLifeCubit, BuildState>(cubit, (cubit, value, context) {
      // Show some view on event
    }, listenWhen: (state) => state is ErrorState);

    final state = useCubitBuilder(
      cubit,
      buildWhen: (state) => [LoadedState, LoadingState, ShowItemState].contains(
        state.runtimeType,
      ),
    );

    return // Build your widget using `state`
  }
```

This code is functionally equivalent to the previous example. It still rebuilds widget in proper way and the right time.
Whole logic of finding proper Cubit/Bloc and providing current state is hidden in `useCubit` and `useCubitBuilder` hooks.

## Setup

Firstly you need to initialize the HookedBloc:

```dart
void main() async {
  //

  await configureDependencies();
  HookedBloc.initialize(() => getIt.get);

  runApp(const MyApp());
}
```

## Basics

### Existing hooks

Hooked Bloc already comes with a few reusable hooks:

<table>
  <tr>
      <th>Name</th>
      <th>Description</th>
  </tr>

  <tr>
    <td>useCubit</td>
    <td>Returns required cubit</td>
  </tr>

  <tr>
    <td>useCubitBuilder</td>
    <td>Returns current cubit state - similar to BlocBuilder</td>
  </tr>

  <tr>
    <td>useCubitListener</td>
    <td>Invokes callback - similar to BlocListener</td>
  </tr>

  <tr>
    <td>useActionListener</td>
    <td>Invokes callback, but independent of Bloc/Cubit state</td>
  </tr>

</table>

### useCubit

`useCubit` hook tries to find Cubit using cubit provider, or - if not specified - looks into widget tree.

Usage:


### useCubitBuilder

Usage:

### useCubitListener

Usage:

### useActionListener

Usage:

## TODO:
1. Unit tests
2. <del>Support for other DI libraries</del>
3. <del>Injector / injection function as a named parameter to `useCubit` method
4. <del>`Readme.md` file</del>
5. Code documentation

## Contributions

Contributions are welcomed!

If you feel that some hook is missing, feel free to open a pull-request.

For a custom-hook to be merged, you will need to do the following:

- Describe the use-case.

  Open an issue explaining why we need this hook, how to use it, ...
  This is important as a hook will not get merged if the hook doesn't appeal to
  a large number of people.

  If your hook is rejected, don't worry! A rejection doesn't mean that it won't
  be merged later in the future if more people show interest in it.
  In the mean-time, feel free to publish your hook as a package on https://pub.dev.

- Write tests for your hook

  A hook will not be merged unless fully tested to avoid inadvertendly breaking it
  in the future.

- Add it to the README and write documentation for it.