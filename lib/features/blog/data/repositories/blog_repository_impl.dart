import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;

  BlogRepositoryImpl(this.blogRemoteDataSource);

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required List<String> topics,
    required String posterId,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: 'imageUrl',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        blog: blogModel,
        image: image,
      );
      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }
  // Add these new methods for likes functionality
  @override
  Future<Either<Failure, void>> likeBlog(String blogId, String userId) async {
    try {
      await blogRemoteDataSource.likeBlog(blogId, userId);
      return right(null);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unlikeBlog(String blogId, String userId) async {
    try {
      await blogRemoteDataSource.unlikeBlog(blogId, userId);
      return right(null);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLikedByUser(String blogId, String userId) async {
    try {
      final isLiked = await blogRemoteDataSource.isLikedByUser(blogId, userId);
      return right(isLiked);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Blog>> getBlogWithLikes(String blogId, String userId) async {
    try {
      final blog = await blogRemoteDataSource.getBlogById(blogId);
      final isLiked = await blogRemoteDataSource.isLikedByUser(blogId, userId);
      
      return right(blog.copyWith(isLiked: isLiked));
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs(int page, int limit) async {
    try {
      final blogs = await blogRemoteDataSource.getAllBlogs(page: page, limit: limit);
      return Right(blogs);
    } on ServerExceptions catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> filterBlogPostsByCategory(
      String category) async {
    try {
      // Call the remote data source to filter blogs by category
      final blogs =
          await blogRemoteDataSource.filterBlogPostsByCategory(category);
      return right(blogs);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> searchBlogPosts(String query) async {
    try {
      // Call the remote data source to search blogs by query
      final blogs = await blogRemoteDataSource.searchBlogPosts(query);
      return right(blogs);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getBlogsByUser(String userId) async {
    try {
      final blogs = await blogRemoteDataSource.getBlogsByUser(userId);
      return right(blogs);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBlog(String blogId) async {
    try {
      await blogRemoteDataSource.deleteBlog(blogId);
      return right(null);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('An unexpected error occurred: $e'));
    }
  }
  
@override
Future<Either<Failure, Blog>> editBlog({
  required String id,
  required String title,
  required File? image, // Make the image parameter optional
  required String content,
  required List<String> topics,
}) async {
  try {
    // Fetch the existing blog to get the current image URL
    final existingBlog = await blogRemoteDataSource.getBlogById(id);

    // If no new image is provided, use the existing image URL
    String imageUrl = existingBlog.imageUrl;

    // If a new image is provided, upload it and update the image URL
    if (image != null) {
      imageUrl = await blogRemoteDataSource.uploadBlogImage(
        blog: existingBlog,
        image: image,
      );
    }

    // Create the updated blog model
    final updatedBlogModel = BlogModel(
      id: existingBlog.id,
      posterId: '',
      title: title,
      content: content,
      imageUrl: imageUrl,
      topics: topics,
      updatedAt: DateTime.now(),
    );

    // Update the blog in the database
    await blogRemoteDataSource.editBlog(
      blog: updatedBlogModel,
      image: image,
    );

    // Return the updated blog
    return right(updatedBlogModel);
  } on ServerExceptions catch (e) {
    return left(Failure(e.message));
  } catch (e) {
    return left(Failure('An unexpected error occurred: $e'));
  }
}
}
