part of 'control_bloc.dart';

@immutable
sealed class ControlState {}

final class ControlInitial extends ControlState {}

final class ControlLoaded extends ControlState {
  final data;
  final int type;
  final int date;
  final int time;
  final int box;
  final String strDate;
  final String strTime;
  final bool isLoading;

  ControlLoaded(
      {required this.isLoading,
      required this.data,
      required this.box,
      required this.strDate,
      required this.strTime,
      required this.type,
      required this.date,
      required this.time});
}

class ControlSuccess extends ControlState {}

class ControlBooked extends ControlState {}
