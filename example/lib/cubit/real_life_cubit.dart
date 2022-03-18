import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingState extends BuildState {}

class LoadedState extends BuildState {
  final List<String> data;

  LoadedState(this.data);
}

class ShowItemState extends BuildState {
  final int index;

  ShowItemState(this.index);
}

class ErrorState extends BuildState {
  final String error;

  ErrorState(this.error);
}

class RealLifeCubit extends Cubit<BuildState> {
  RealLifeCubit() : super(LoadingState());

  List<String> data = List.generate(100, (index) => "List item $index");

  Future<void> loadData() async {
    // Imitate fetching the data from an API
    final response = await Future.delayed(
      const Duration(seconds: 3),
      () => data,
    );

    emit(LoadedState(response));
  }

  void goToItem(int index) {
    if (index.isEven) {
      emit(ShowItemState(index));
    } else {
      emit(ErrorState("Cannot open an item with the odd index"));
    }
  }

  void closeDetails() {
    emit(LoadedState(data));
  }
}
