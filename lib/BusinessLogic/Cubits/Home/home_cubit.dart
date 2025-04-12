import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(currentIndex: 0));

  void changeSelectedIndex(int index) => emit(HomeState(currentIndex: index));
}