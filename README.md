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

Flutter package that simplifies injection and usage of <a href="https://pub.dev/packages/flutter_bloc"> Bloc/Cubit</a>. The library is based on the concept of hooks originally introduced in React Native and adapted to Flutter. <a href="https://github.com/rrousselGit/flutter_hooks">Flutter hooks</a> allow you to extract view's logic into common use cases and reuse them, what makes writing widgets faster and easier.

## Motivation

When you want to use Bloc/Cubit in your application you have to somehow find it in the widget tree. It is kinda annoying.
Each time you have to use `BlocBuilder`, `BlocListener` or `BlocSelector`. What if we can use a power of Flutter hooks?


So, instead of this:
```dart
class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return CounterCubit("Provider");
      },
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContentBlocBuilder extends StatelessWidget {
  const _HomePageContentBlocBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: BlocBuilder<CounterCubit, int>(
        builder: (context, count) => Center(
          child: Text('$count'),
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => context.read<CounterCubit>().increment(),
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: () => context.read<CounterCubit>().decrement(),
          ),
        ],
      ),
    );
  }
}
```

We can have this:

```dart
class _HomePageContentHooks extends HookWidget {
  const _HomePageContentHooks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CounterCubit cubit = useCubit<CounterCubit>();
    final int state = useCubitBuilder(cubit, buildWhen: (_) => true);

    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(child: Text('$state')),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: cubit.increment,
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: cubit.decrement,
          ),
        ],
      ),
    );
  }
}
```

This code is functionally equivalent to the previous example. It still rebuilds widget in proper way and the right time.
The question is

> What's going on?

Whole logic to find proper Cubit/Bloc, provide current state is hidden in `useCubit` and `useCubitBuilder` hooks.


## How does it work?

//todo: add cool description how does our hooks works.

`useCubit` hook tries to find Cubit using cubit provider, or - if not specified - looks into widget tree.


## Existing hooks

**Hooked_bloc** already comes with a few reusable hooks:

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