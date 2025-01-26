import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteUserBlog implements UseCase<void, String> {
  final BlogRepository blogRepository;

  DeleteUserBlog(this.blogRepository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await blogRepository.deleteBlog(params);
  }
}