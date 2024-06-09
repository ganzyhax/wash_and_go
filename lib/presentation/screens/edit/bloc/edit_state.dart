part of 'edit_bloc.dart';

@immutable
sealed class EditState {}

final class EditInitial extends EditState {}

final class EditLoaded extends EditState {
  List images;
  List times;
  List location;
  final bool isLoading;
  var data;

  EditLoaded(
      {required this.images,
      required this.times,
      required this.data,
      required this.isLoading,
      required this.location});
}
