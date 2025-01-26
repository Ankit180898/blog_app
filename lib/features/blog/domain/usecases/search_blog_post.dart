import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class SearchBlogPosts {
  final BlogRepository repository;

  SearchBlogPosts(this.repository);

  Future<Either<Failure, List<Blog>>> call(String query) async {
    return await repository.searchBlogPosts(query);
  }
}
