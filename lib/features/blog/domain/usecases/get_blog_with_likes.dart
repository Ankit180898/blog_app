import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

// get_blog_with_likes_usecase.dart
class GetBlogWithLikesParams {
  final String blogId;
  final String userId;

  GetBlogWithLikesParams({required this.blogId, required this.userId});
}

class GetBlogWithLikes implements UseCase<Blog, GetBlogWithLikesParams> {
  final BlogRepository blogRepository;
  
  GetBlogWithLikes(this.blogRepository);
  
  @override
  Future<Either<Failure, Blog>> call(GetBlogWithLikesParams params) async {
    return await blogRepository.getBlogWithLikes(params.blogId, params.userId);
  }
}