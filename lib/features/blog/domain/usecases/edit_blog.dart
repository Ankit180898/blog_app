import 'dart:io';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class EditBlog {
  final BlogRepository blogRepository;

  EditBlog(this.blogRepository);

  Future<Either<Failure, Blog>> call(EditBlogParams params) async {
    return await blogRepository.editBlog(
      id: params.id,
      title: params.title,
      image: params.image,
      content: params.content,
      topics: params.topics,
    );
  }
}

class EditBlogParams {
  final String id;
  final String title;
  final File image;
  final String content;
  final List<String> topics;
  EditBlogParams({
    required this.id,
    required this.title,
    required this.image,
    required this.content,
    required this.topics,
  });
}
