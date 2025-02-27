part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess({required this.user});
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});
}

final class AuthLogoutSuccess extends AuthState {}

final class AuthEditSuccess extends AuthState {
  final User user;

  const AuthEditSuccess({required this.user});
}

final class AuthDeleteSuccess extends AuthState {}
