part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

/// Initial state when the app is started
final class AppUserInitial extends AppUserState {}

/// State when the user is logged in
final class AppUserLoggedIn extends AppUserState {
  final User user;
  AppUserLoggedIn(this.user);
}

/// State when the user is logged out
final class AppUserLoggedOut extends AppUserState {
  AppUserLoggedOut();
}
