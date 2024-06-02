part of 'control_bloc.dart';

@immutable
sealed class ControlEvent {}

class ControlLoad extends ControlEvent {}

final class ControlChooseType extends ControlEvent {
  final int index;
  ControlChooseType({required this.index});
}

final class ControlChooseBox extends ControlEvent {
  final int index;

  ControlChooseBox({required this.index});
}

final class ControlChooseDate extends ControlEvent {
  final int index;
  final String date;
  ControlChooseDate({required this.index, required this.date});
}

final class ControlChooseTime extends ControlEvent {
  final int index;
  final String time;

  ControlChooseTime({required this.index, required this.time});
}

final class ControlBook extends ControlEvent {
  final String id;
  ControlBook({required this.id});
}
