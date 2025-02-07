// like_blog_usecase.dart
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class LikeBlogParams {
  final String blogId;
  final String userId;

  LikeBlogParams({required this.blogId, required this.userId});
}

class LikeBlog implements UseCase<void, LikeBlogParams> {
  final BlogRepository blogRepository;
  
  LikeBlog(this.blogRepository);
  
  @override
  Future<Either<Failure, void>> call(LikeBlogParams params) async {
    return await blogRepository.likeBlog(params.blogId, params.userId);
  }
}