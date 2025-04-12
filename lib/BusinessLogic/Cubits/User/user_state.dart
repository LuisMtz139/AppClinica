part of 'user_cubit.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded({required this.user});
}

class UserSaved extends UserState {}

class UserUpdated extends UserState {}

class UserError extends UserState {
  final String errorMessage;

  UserError(this.errorMessage);
}