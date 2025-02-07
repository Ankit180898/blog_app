import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecases/like_blog_usecase.dart';
import 'package:fpdart/fpdart.dart';

// is_blog_liked_by_user_usecase.dart
class IsBlogLikedByUser implements UseCase<bool, LikeBlogParams> {
  final BlogRepository blogRepository;
  
  IsBlogLikedByUser(this.blogRepository);
  
  @override
  Future<Either<Failure, bool>> call(LikeBlogParams params) async {
    return await blogRepository.isLikedByUser(params.blogId, params.userId);
  }
}