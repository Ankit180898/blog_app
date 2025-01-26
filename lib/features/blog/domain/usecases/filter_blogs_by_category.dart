import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class FilterBlogPostsByCategory implements UseCase<List<Blog>, String> {
  final BlogRepository repository;

  FilterBlogPostsByCategory(this.repository);

  @override
  Future<Either<Failure, List<Blog>>> call(String category) async {
    return await repository.filterBlogPostsByCategory(category);
  }
}
