import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogSearchDelegate extends SearchDelegate<String> {
  final BlogBloc blogBloc;

  BlogSearchDelegate({required this.blogBloc});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Close the search delegate
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Dispatch the search event when the user submits a query
    blogBloc.add(SearchBlogPostsEvent(query));

    return BlocBuilder<BlogBloc, BlogState>(
      builder: (context, state) {
        if (state is BlogLoading) {
          return const Center(child: Loader()); // Show a loader while loading
        } else if (state is BlogsDisplaySuccess) {
          if (state.blogs.isEmpty) {
            return const Center(child: Text('No results found.')); // No results
          }
          return ListView.builder(
            itemCount: state.blogs.length,
            itemBuilder: (context, index) {
              return BlogCard(blog: state.blogs[index]); // Display blog cards
            },
          );
        } else if (state is BlogFailure) {
          return Center(child: Text(state.error)); // Show error message
        }
        return const Center(child: Text('Start typing to search...'));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions while the user is typing
    return const Center(child: Text('Start typing to search...'));
  }
}