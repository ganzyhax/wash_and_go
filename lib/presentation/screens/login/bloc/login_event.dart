part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginLoad extends LoginEvent {}