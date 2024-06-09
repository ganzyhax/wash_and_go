part of 'statistics_bloc.dart';

@immutable
sealed class StatisticsState {}

final class StatisticsInitial extends StatisticsState {}

final class StatisticsLoaded extends StatisticsState {
  final data;
  int index;
  StatisticsLoaded({required this.data, required this.index});
}
