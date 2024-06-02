part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final data;
  ProfileLoaded({required this.data});
}
