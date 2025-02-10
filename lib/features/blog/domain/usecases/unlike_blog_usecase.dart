// like_blog_usecase.dart
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UnlikeBlogParams {
  final String blogId;
  final String userId;

  UnlikeBlogParams({required this.blogId, required this.userId});
}

class UnlikeBlog implements UseCase<void, UnlikeBlogParams> {
  final BlogRepository blogRepository;
  
  UnlikeBlog(this.blogRepository);
  
  @override
  Future<Either<Failure, void>> call(UnlikeBlogParams params) async {
    return await blogRepository.unlikeBlog(params.blogId, params.userId);
  }
}