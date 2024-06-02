part of 'create_bloc.dart';

@immutable
sealed class CreateState {}

final class CreateInitial extends CreateState {}

final class CreateLoaded extends CreateState {
  List images;
  List times;
  List location;
  final bool isLoading;

  CreateLoaded(
      {required this.images,
      required this.times,
      required this.location,
      required this.isLoading});
}
