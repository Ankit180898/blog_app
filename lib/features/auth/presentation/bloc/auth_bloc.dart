
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/delete_account.dart';
import 'package:blog_app/features/auth/domain/usecases/edit_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_logout.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final UserLogout _userLogout;
  final AppUserCubit _appUserCubit;
  final EditProfile _editProfile;
  final DeleteAccount _deleteAccount;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required UserLogout userLogout,
    required AppUserCubit appUserCubit,
    required EditProfile editProfile,
    required DeleteAccount deleteAccount,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _userLogout = userLogout,
        _appUserCubit = appUserCubit,
        _editProfile = editProfile,
        _deleteAccount = deleteAccount,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthLoggedIn>(_isUserLoggedIn);
    on<AuthLogout>(_onAuthLogout);
    on<AuthEditUser>(_onAuthEditUser);
    on<AuthDeleteUser>(_onAuthDeleteUser);
  }

  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignUp(UserSignUpParams(
      email: event.email,
      password: event.password,
      name: event.name,
    ));
    res.fold((l) => emit(AuthFailure(message: l.message)),
        (r) => _emitAuthSuccess(r, emit));
  }

  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userLogin(UserLoginParams(
      email: event.email,
      password: event.password,
    ));
    res.fold((l) => emit(AuthFailure(message: l.message)),
        (r) => _emitAuthSuccess(r, emit));
  }

  void _isUserLoggedIn(
    AuthLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _currentUser(
      NoParams(),
    );
    res.fold((l) => emit(AuthFailure(message: l.message)),
        (r) => _emitAuthSuccess(r, emit));
  }

  void _emitAuthSuccess(
    User user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }

  void _onAuthLogout(
    AuthLogout event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userLogout(NoParams());
    res.fold((l) => emit(AuthFailure(message: l.message)),
        (_) => emit(AuthLogoutSuccess()));
  }

  void _onAuthEditUser(
    AuthEditUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _editProfile(EditUserParams(userId: event.userId));
    res.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthDeleteUser(
    AuthDeleteUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _deleteAccount(userId: event.userId);
    res.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (_) => emit(AuthDeleteSuccess()),
    );
  }
}
