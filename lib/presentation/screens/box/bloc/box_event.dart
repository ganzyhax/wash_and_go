part of 'box_bloc.dart';

@immutable
sealed class BoxEvent {}

final class BoxLoad extends BoxEvent {
  final commentData;
  BoxLoad({required this.commentData});
}

final class BoxChooseType extends BoxEvent {
  final int index;
  BoxChooseType({required this.index});
}

final class BoxChooseDate extends BoxEvent {
  final int index;
  final String date;
  BoxChooseDate({required this.index, required this.date});
}

final class BoxChooseTime extends BoxEvent {
  final int index;
  final String time;

  BoxChooseTime({required this.index, required this.time});
}

final class BoxBook extends BoxEvent {
  final String id;
  BoxBook({required this.id});
}

final class BoxChangeTabIndex extends BoxEvent {
  int index;
  BoxChangeTabIndex({required this.index});
}

final class BoxChangeRate extends BoxEvent {
  int rate;
  BoxChangeRate({required this.rate});
}

final class BoxAddComment extends BoxEvent {
  final String name;
  final String comment;
  final int rate;
  final String id;
  BoxAddComment(
      {required this.comment,
      required this.name,
      required this.rate,
      required this.id});
}

final class BoxAddCommentsLocal extends BoxEvent {
  final data;
  BoxAddCommentsLocal({required this.data});
}
