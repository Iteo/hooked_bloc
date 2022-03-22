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
<img width="200" src="hooked_bloc_icon.png">
</p>

# Hooked Bloc

Flutter package that simplifies injection and usage of <a href="https://pub.dev/packages/flutter_bloc"> Bloc/Cubit</a>.
The library is based on the concept of hooks originally introduced in React Native and adapted to Flutter.
<a href="https://github.com/rrousselGit/flutter_hooks">Flutter hooks</a> allow you to extract view's logic
into common use cases and reuse them, what makes writing widgets faster and easier.


## Contents

- [Motivation](#Motivation)
- [Installation](#Installation)
- [Setup](#Setup)
- [Basics](#Basics)
	- [useCubit](#useCubit)
	- [useCubitBuilder](#useCubitBuilder)
	- [useCubitListener](#useCubitListener)
	- [useActionListener](#useActionListener)
- [Contribution](#Contribution)

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

Full example can be found in <a href="https://github.com/Iteo/hooked_bloc/tree/develop/example">here</a>

## Installation  

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

## Setup

Install package

```shell
flutter pub add hooked_bloc
```

After that you need to initialize the HookedBloc:

```dart
void main() async {
  // With GetIt or Injectable
    await configureDependencies();
    HookedBloc.initialize(() => getIt.get,
      builderCondition: (state) => state != null, // Global build condition
      listenerCondition: (state) => state != null, // Global listen condition
    );

  // Or create your own initializer with default conditions (always allow)
  // HookedBloc.initialize(() {
  //   return <T extends Object>() {
  //     if (T == MyCubit) {
  //       return MyCubit() as T;
  //     } else {
  //       return ...
  //     }
  //   };
  // });

  // Or you can omit HookedBloc.initialize(...)
  // and allow library to find the cubit in the widget tree

  runApp(const MyApp());
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
    final cubit = useCubit<CounterCubit>();
    // Then observe state's updates
    // `buildWhen` param will override builderCondition locally
    final state = useCubitBuilder(cubit, buildWhen: (state) => state <= 10);
    // Create a listener for the side-effect
    useCubitListener(cubit, (cubit, value, context) {
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

```dart
  @override
  Widget build(BuildContext context) {
    // The hook will provide the expected object
    final cubit = useCubit<SimpleCubit>(
      // For default hook automatically closes cubit
      closeOnDispose: true,
    );

    return // Access provided cubit 
  }
```

### useCubitBuilder

`useCubitBuilder` hook rebuilds the widget when new state appears

```dart
  final CounterCubit cubit = CounterCubit("My cubit");

  @override
  Widget build(BuildContext context) {
    // The state will be updated along with the widget
    // For default the state will be updated basing on `builderCondition`

    final int state = useCubitBuilder(cubit);

    return // Access provided state 
  }

```

### useCubitListener

`useCubitListener` hook allows to observe cubit's states that represent action (e.x. show Snackbar)

```dart
  final EventCubit cubit = EventCubit();

  @override
  Widget build(BuildContext context) {
    // Handle state as event independently of the view state
    useCubitListener(cubit, (_, value, context) {
      _showMessage(context, (value as ShowMessage).message);
    }, listenWhen: (state) => state is ShowMessage);

    return // Build your widget
  }
```

### useActionListener

`useActionListener` hook is similar to the `useCubitListener` but listens to the stream
different than state's stream and can be used for actions that require different flow of notifying.

Because of that your bloc/cubit must use `BlocActionMixin`

```dart
// You can use also ActionCubit base class
class MessageActionCubit extends EventCubit with BlocActionMixin<String, BuildState> {

  // The method used to publish events
  @override
  void dispatch(String action) {
    super.dispatch(action);
  }
}
```

Then consume results as you would do with `useCubitListener`

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

## Contribution

We accept any contribution to the project!

Suggestions of a new feature or fix should be created via pull-request or issue.

### feature request:

- Check if feature is already addressed or declined

- Describe why this is needed

  Just create an issue with label `enhancement` and descriptive title. Then provide a description
  and/or example code. This will help the community to understand need for it.

- Write tests for your hook

  The test is a best way to explain how proposed hook should work. We demand a complete
  test before any code is merged in order to ensure cohesion with existing codebase.

- Add it to the README and write documentation for it

  Add new hook to the existing hooks table and append sample code with usage.

### Fix

- Check if bug was already found

- Describe what is broken

  Minimal requirement to report a bug fix is a reproduction path. Write steps that should be
  followed to find a problem in code. Perfect situation is when you give full description
  why some code doesn't work and solution code.

- Write tests for your hook

  The test should show that your fix corrects the problem. You can start with straightforward
  test and then think about potential edge cases or other places that can be broken.

- Add it to the README and write documentation for it

  If your fix changed behavior of the library or requires any other extra steps from user,
  this should be full described in README.