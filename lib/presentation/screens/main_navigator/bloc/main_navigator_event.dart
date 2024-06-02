part of 'main_navigator_bloc.dart';

@immutable
sealed class MainNavigatorEvent {}

class MainNavigatorLoad extends MainNavigatorEvent {}

// ignore: must_be_immutable
class MainNavigatorChangePage extends MainNavigatorEvent {
  int index;
  bool? withChange = false;
  MainNavigatorChangePage({required this.index, this.withChange});
}
