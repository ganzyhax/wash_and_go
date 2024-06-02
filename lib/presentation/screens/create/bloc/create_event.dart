part of 'create_bloc.dart';

@immutable
sealed class CreateEvent {}

final class CreateLoad extends CreateEvent {}

final class CreateImageAdd extends CreateEvent {}

final class CreateTimeStartPick extends CreateEvent {
  var date;
  CreateTimeStartPick({required this.date});
}

final class CreateTimeEndPick extends CreateEvent {
  var date;
  CreateTimeEndPick({required this.date});
}

final class CreateFinish extends CreateEvent {
  String name;
  String description;
  String adress;
  String phone;
  String price1;
  String price2;
  String price3;
  String washCount;
  BuildContext context;
  CreateFinish(
      {required this.name,
      required this.description,
      required this.adress,
      required this.phone,
      required this.price1,
      required this.price2,
      required this.price3,
      required this.washCount,
      required this.context});
}

final class CreateLocationUpdate extends CreateEvent {
  List data;
  CreateLocationUpdate({required this.data});
}
