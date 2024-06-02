part of 'statistics_bloc.dart';

@immutable
sealed class StatisticsState {}

final class StatisticsInitial extends StatisticsState {}

final class StatisticsLoaded extends StatisticsState {
  final data;
  StatisticsLoaded({required this.data});
}
