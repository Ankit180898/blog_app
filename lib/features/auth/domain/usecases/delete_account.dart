import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteAccount {
  final AuthRepository authRepository;

  DeleteAccount(this.authRepository);

  Future<Either<Failure, void>> call({
    required String userId,
  }) {
    return authRepository.deleteUser(userId: userId);
  }
}
