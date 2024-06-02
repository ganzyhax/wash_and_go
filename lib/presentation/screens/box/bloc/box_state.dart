part of 'box_bloc.dart';

@immutable
sealed class BoxState {}

final class BoxInitial extends BoxState {}

final class BoxLoaded extends BoxState {
  final int type;
  final int date;
  final int time;
  final String strDate;
  final String strTime;
  final bool isAvailable;
  final bool isLoading;
  final int selectedTab;
  final int rate;
  final List comments;
  BoxLoaded(
      {required this.type,
      required this.isLoading,
      required this.rate,
      required this.date,
      required this.time,
      required this.selectedTab,
      required this.comments,
      required this.isAvailable,
      required this.strDate,
      required this.strTime});
}

final class BoxBookSuccess extends BoxState {}

final class BoxBookBooked extends BoxState {}
