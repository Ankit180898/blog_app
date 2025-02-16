import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogSearchDelegate extends SearchDelegate<String> {
  final BlogBloc blogBloc;
  final String currentUserId;

  BlogSearchDelegate({
    required this.blogBloc,
    required this.currentUserId,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: AppPalette.backgroundColor,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: theme.textTheme.bodyLarge?.copyWith(
          color: AppPalette.textGrey,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      AnimatedOpacity(
        opacity: query.isEmpty ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
        // Reset search state when closing
        blogBloc.add(BlogFetchAllBlogs());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return const Center(
        child: Text('Please enter a search term'),
      );
    }

    blogBloc.add(SearchBlogPostsEvent(query));

    return BlocBuilder<BlogBloc, BlogState>(
      builder: (context, state) {
        if (state is BlogLoading) {
          return const Center(child: Loader());
        }

        if (state is BlogsDisplaySuccess) {
          if (state.blogs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'No results found for "$query"',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.blogs.length,
            itemBuilder: (context, index) {
              final blog = state.blogs[index];
              return BlogCard(
                key: ValueKey(blog.id),
                blog: blog,
                onLike: () {
                  blogBloc.add(LikeBlogEvent(
                    blogId: blog.id,
                    userId: currentUserId,
                  ));
                },
                onUnlike: () {
                  blogBloc.add(UnlikeBlogEvent(
                    blogId: blog.id,
                    userId: currentUserId,
                  ));
                },
                isLiked: blog.isLiked,
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        }

        if (state is BlogFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error: ${state.error}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 48, color: AppPalette.textGrey),
            const SizedBox(height: 16),
            Text(
              'Search for blogs',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppPalette.textGrey,
                  ),
            ),
          ],
        ),
      );
    }

    // Automatically show results as user types
    return buildResults(context);
  }
}