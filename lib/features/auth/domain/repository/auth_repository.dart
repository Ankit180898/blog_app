import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();

  Future<Either<Failure, User>> logout();

  // Edit user profile
  Future<Either<Failure, User>> editUser({
    required String userId,
    String? name,
    String? email,
    String? password,
  });

  // Delete user account
  Future<Either<Failure, void>> deleteUser({required String userId});
}
