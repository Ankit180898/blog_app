import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUserBlogs implements UseCase<List<Blog>, String> {
  final BlogRepository blogRepository;

  GetUserBlogs(this.blogRepository);

  @override
  Future<Either<Failure, List<Blog>>> call(String params) async {
    return await blogRepository.getBlogsByUser(params);
  }
}