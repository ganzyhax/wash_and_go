part of 'statistics_bloc.dart';

@immutable
sealed class StatisticsEvent {}

class StatisticsLoad extends StatisticsEvent {}

class StatisticsChangeIndex extends StatisticsEvent {
  int index;
  StatisticsChangeIndex({required this.index});
}
