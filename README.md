<div align="center">

<img width="200" src="https://github.com/Iteo/hooked_bloc/raw/main/hooked_bloc_icon.png">
<br /><br />

[![Build](https://github.com/Iteo/hooked_bloc/workflows/Build/badge.svg)](https://github.com/Iteo/hooked_bloc/actions?query=workflow%3ATest)
&nbsp;
[![codecov](https://codecov.io/gh/Iteo/hooked_bloc/branch/main/graph/badge.svg)](https://codecov.io/gh/Iteo/hooked_bloc)
&nbsp;
[![pub package](https://img.shields.io/pub/v/hooked_bloc.svg)](https://pub.dartlang.org/packages/hooked_bloc) &nbsp;
[![stars](https://img.shields.io/github/stars/Iteo/hooked_bloc.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/Iteo/hooked_bloc)
&nbsp;
[![GitHub license](https://img.shields.io/github/license/Iteo/hooked_bloc)](https://github.com/Iteo/hooked_bloc/blob/main/LICENSE) &nbsp;

</div>

---

# Hooked Bloc

Flutter package that simplifies injection and usage of <a href="https://pub.dev/packages/flutter_bloc"> Bloc/Cubit</a>.
The library is based on the concept of hooks originally introduced in React Native and adapted to Flutter.
<a href="https://github.com/rrousselGit/flutter_hooks">Flutter hooks</a> allow you to extract view's logic into common
use cases and reuse them, which makes writing widgets faster and easier.

## Contents

<!-- pub.dev accepts anchors only with lowercase -->

- [Motivation](#motivation)
- [Setup](#setup)
- [Basics](#basics)
    - [useBloc](#usebloc)
    - [useBlocFactory](#useblocfactory)
    - [useBlocBuilder](#useblocbuilder)
    - [useBlocListener](#usebloclistener)
    - [useActionListener](#useactionlistener)
- [Contribution](#contribution)

## Motivation

When you want to use Bloc/Cubit in your application you have to provide an instance of the object down the widgets tree
for state receivers. This is mostly achieved by `BlocBuilder` along with `BlocProvider` and enlarges complexity of the
given widget.

Each time you have to use `BlocBuilder`, `BlocListener` or `BlocSelector`. What if we could use the power of Flutter
hooks?

So, instead of this:

```dart
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: ...,
    body: BlocProvider<RealLifeCubit>(
      create: (context) =>
      RealLifeCubit()
        ..loadData(),
      child: BlocListener<RealLifeCubit, hooked.BuildState>(
        listenWhen: (_, state) => state is ErrorState,
        listener: (context, state) {
          // Show some view on event
        },
        child: BlocBuilder<RealLifeCubit, hooked.BuildState>(
          buildWhen: (_, state) =>
              [LoadedState, LoadingState, ShowItemState]
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
  final cubit = useBloc<RealLifeCubit>();

  useBlocListener<RealLifeCubit, BuildState>(cubit, (cubit, value, context) {
    // Show some view on event
  }, listenWhen: (state) => state is ErrorState);

  final state = useBlocBuilder(
    cubit,
    buildWhen: (state) =>
        [LoadedState, LoadingState, ShowItemState].contains(
          state.runtimeType,
        ),
  );

  return // Build your widget using `state`
}
```

This code is functionally equivalent to the previous example. It still rebuilds the widget in the proper way and the
right time. Whole logic of finding adequate Cubit/Bloc and providing current state is hidden in `useBloc`
and `useBlocBuilder` hooks.

Full example can be found in <a href="https://github.com/Iteo/hooked_bloc/tree/develop/example">here</a>

## Setup

Install package

Run command:

```shell
flutter pub add hooked_bloc
```

Or manually add the dependency in the `pubspec.yaml`

```yaml
dependencies:
  # Library already contains flutter_hooks package
  hooked_bloc:
```

After that you can (it's optional) initialize the HookedBloc:

```dart
void main() async {
  // With GetIt or Injectable
  await configureDependencies();

  runApp(
    HookedBlocConfigProvider(
      injector: () => getIt.get,
      builderCondition: (state) => state != null, // Global build condition
      listenerCondition: (state) => state != null, // Global listen condition
      child: const MyApp(),
    )
  );

  // Or you can omit HookedBlocInjector(...)
  // and allow library to find the cubit in the widget tree
}
```

Then you can simply start writing your widget with hooks

```dart
// Remember to inherit from HookWidget
class MyApp extends HookWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // At start obtain a cubit instance
    final cubit = useBloc<CounterCubit>();
    // Then observe state's updates
    // `buildWhen` param will override builderCondition locally
    final state = useBlocBuilder(cubit, buildWhen: (state) => state <= 10);
    // Create a listener for the side-effect
    useBlocListener(cubit, (cubit, value, context) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Button clicked"),
          ));
    });

    // Build widget's tree without BlocProvider
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => cubit.increment(), // Access cubit in tree
          child: const Icon(Icons.add),
        ),
        // Consume state without BlocBuilder
        body: Center(child: Text("The button has been pressed $state times")),
      ),
    );
  }
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
    <td>useBloc</td>
    <td>Returns required Cubit/Bloc</td>
  </tr>

  <tr>
    <td>useBlocFactory</td>
    <td>Returns desired Cubit/Bloc by creating it with provided factory</td>
  </tr>

  <tr>
    <td>useBlocBuilder</td>
    <td>Returns current Cubit/Bloc state - similar to BlocBuilder</td>
  </tr>

  <tr>
    <td>useBlocListener</td>
    <td>Invokes callback - similar to BlocListener</td>
  </tr>

  <tr>
    <td>useActionListener</td>
    <td>Invokes callback, but independent of Bloc/Cubit state</td>
  </tr>

</table>

### useBloc

`useBloc` hook tries to find Cubit using the cubit provider, or - if not specified - looks into the widget tree.

```dart
  @override
Widget build(BuildContext context) {
  // The hook will provide the expected object
  final cubit = useBloc<SimpleCubit>(
    // For default hook automatically closes cubit
    closeOnDispose: true,
  );

  return // Access provided cubit
}
```

### useBlocFactory

`useBlocFactory` hook tries to find factory using provided injection method and then returns cubit created by it

```dart
class SimpleCubitFactory extends BlocFactory<SimpleCubit> {
  bool _value = true;

  @override
  SimpleCubit create() {
    return _value ? SimpleCubitA() : SimpleCubitB();
  }

  // This is example method which you can add to configure your cubit creation on run
  void configure(bool value) {
    _value = value;
  }
}

@override
Widget build(BuildContext context) {
  // The hook will provide the expected object
  final cubit = useBlocFactory<SimpleCubit, SimpleCubitFactory>(
    onCubitCreate: (cubitFactory) {
      cubitFactory.configure(false);
    }
  );

  return // Access provided cubit
}
```

### useBlocBuilder

`useBlocBuilder` hook rebuilds the widget when new state appears

```dart

final CounterCubit cubit = CounterCubit("My cubit");

@override
Widget build(BuildContext context) {
  // The state will be updated along with the widget
  // For default the state will be updated basing on `builderCondition`
  final int state = useBlocBuilder(cubit);

  return // Access provided state
}

```

### useBlocListener

`useBlocListener` hook allows to observe cubit's states that represent action (e.g. show Snackbar)

```dart

final EventCubit cubit = EventCubit();

@override
Widget build(BuildContext context) {
  // Handle state as event independently of the view state
  useBlocListener(cubit, (_, value, context) {
    _showMessage(context, (value as ShowMessage).message);
  }, listenWhen: (state) => state is ShowMessage);

  return // Build your widget
}
```

### useActionListener

`useActionListener` hook is similar to the `useBlocListener` but listens to the stream different than state's stream
and can be used for actions that require a different flow of notifying.

Because of that your bloc/cubit must use `BlocActionMixin`

```dart
class MessageActionCubit extends EventCubit with BlocActionMixin<String, BuildState> {

  // The method used to publish events
  @override
  void dispatch(String action) {
    super.dispatch(action);
  }
}
```

Then, consume results as you would do with `useBlocListener`

```dart
  @override
Widget build(BuildContext context) {
  // Handle separate action stream with values other than a state type
  useActionListener(cubit, (String action) {
    _showMessage(context, action);
  });

  return // Build your widget
}

```

Instead of `BlocActionMixin` you can use one of our classes: `ActionCubit` or `ActionBloc`

```dart
class MessageActionCubit extends ActionCubit<BuildState, String>  {
  // The method used to publish events
  @override
  void dispatch(String action) {
    super.dispatch(action);
  }
}
```

```dart
class MessageActionBloc extends ActionBloc<BuildState, BlocEvent, String>  {
  // The method used to publish events
  @override
  void dispatch(String action) {
    super.dispatch(action);
  }
}
```

## Contribution

We accept any contribution to the project!

Suggestions of a new feature or fix should be created via pull-request or issue.

### feature request:

- Check if feature is already addressed or declined

- Describe why this is needed

  Just create an issue with label `enhancement` and descriptive title. Then, provide a description and/or example code.
  This will help the community to understand the need for it.

- Write tests for your hook

  The test is the best way to explain how the proposed hook should work. We demand a complete test before any code is
  merged in order to ensure cohesion with existing codebase.

- Add it to the README and write documentation for it

  Add a new hook to the existing hooks table and append sample code with usage.

### Fix

- Check if bug was already found

- Describe what is broken

  The minimum requirement to report a bug fix is a reproduction path. Write steps that should be followed to find a
  problem in code. Perfect situation is when you give full description why some code doesn't work and a solution code.

- Write tests for your hook

  The test should show that your fix corrects the problem. You can start with straightforward test and then think about
  potential edge cases or other places that can be broken.

- Add it to the README and write documentation for it

  If your fix changed behavior of the library or requires any other extra steps from user, this should be fully
  described in README.

## Contributors

<div align="left">
  <a href="https://github.com/Iteo/hooked_bloc/graphs/contributors">
   <img src="https://contrib.rocks/image?repo=Iteo/hooked_bloc"/>
  </a>
</div>
