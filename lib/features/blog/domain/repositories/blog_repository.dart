import 'dart:io';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required List<String> topics,
    required String posterId,
  });
  Future<Either<Failure, List<Blog>>> getAllBlogs();
  Future<Either<Failure, List<Blog>>> filterBlogPostsByCategory(
      String category);
  Future<Either<Failure, List<Blog>>> searchBlogPosts(String query);
  Future<Either<Failure, List<Blog>>> getBlogsByUser(String userId);
  Future<Either<Failure, void>> deleteBlog(String blogId);
  Future<Either<Failure, Blog>> editBlog({
    required String id,
    required String title,
    required File? image,
    required String content,
    required List<String> topics,
  });

  // Add these new methods
  Future<Either<Failure, void>> likeBlog(String blogId, String userId);
  Future<Either<Failure, void>> unlikeBlog(String blogId, String userId);
  Future<Either<Failure, bool>> isLikedByUser(String blogId, String userId);
  Future<Either<Failure, Blog>> getBlogWithLikes(String blogId, String userId);
}
