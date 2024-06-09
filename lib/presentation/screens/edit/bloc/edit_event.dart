part of 'edit_bloc.dart';

@immutable
sealed class EditEvent {}

final class EditLoad extends EditEvent {
  String id;
  EditLoad({required this.id});
}

final class EditImageAdd extends EditEvent {}

final class EditTimeStartPick extends EditEvent {
  var date;
  EditTimeStartPick({required this.date});
}

final class EditTimeEndPick extends EditEvent {
  var date;
  EditTimeEndPick({required this.date});
}

final class EditLocationUpdate extends EditEvent {
  List data;
  EditLocationUpdate({required this.data});
}

final class EditFinish extends EditEvent {
  String name;
  String description;
  String adress;
  String phone;
  String price1;
  String price2;
  String price3;
  String washCount;
  String id;
  BuildContext context;
  EditFinish(
      {required this.name,
      required this.description,
      required this.adress,
      required this.phone,
      required this.id,
      required this.price1,
      required this.price2,
      required this.price3,
      required this.washCount,
      required this.context});
}
