import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class EditProfile {
  final AuthRepository authRepository;

  EditProfile(this.authRepository);

  Future<Either<Failure, User>> call(EditUserParams params) {
    return authRepository.editUser(
      userId: params.userId,
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class EditUserParams {
  final String userId;
  String? email;
  String? name;
  String? password;

  EditUserParams({
    required this.userId,
    this.email,
    this.name,
    this.password,
  });
}
