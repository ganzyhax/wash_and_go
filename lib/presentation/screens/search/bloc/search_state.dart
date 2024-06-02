part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLaoded extends SearchState {
  List<CarWahserEntity> washes;

  SearchLaoded({required this.washes});
}
