part of 'main_navigator_bloc.dart';

@immutable
sealed class MainNavigatorState {}

final class MainNavigatorInitial extends MainNavigatorState {}

final class MainNavigatorLoaded extends MainNavigatorState {
  List screens;
  int index;
  MainNavigatorLoaded({required this.screens, required this.index});
}
