import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/edit_user_blog_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserBlogsPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const UserBlogsPage());
  const UserBlogsPage({super.key});

  @override
  State<UserBlogsPage> createState() => _UserBlogsPageState();
}

class _UserBlogsPageState extends State<UserBlogsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch blogs posted by the current user
    final userId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    context.read<BlogBloc>().add(FetchUserBlogsEvent(userId));
  }
  

  void _deleteBlog(String blogId) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Blog'),
        content: const Text('Are you sure you want to delete this blog?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<BlogBloc>().add(DeleteBlogEvent(blogId));
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _editBlog(BuildContext context, Blog blog) {
    Navigator.push(
      context,
      EditUserBlogPage.route(
        blogId: blog.id,
        initialContent: blog.content,
        initialImage: blog.imageUrl,
        initialTitle: blog.title,
        initialTopics: blog.topics,
      ), // Pass the blog to edit
    ).then((_) {
      // Refresh the list after editing
      final userId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(FetchUserBlogsEvent(userId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Blogs'),
        centerTitle: true,
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error);
          } else if (state is BlogDeleteSuccess) {
            showSnackbar(context, 'Blog deleted successfully');
            // Refresh the list after deletion
            final userId =
                (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
            context.read<BlogBloc>().add(FetchUserBlogsEvent(userId));
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: Loader());
          }
          if (state is BlogsDisplaySuccess) {
            if (state.blogs.isEmpty) {
              return const Center(child: Text('No blogs found.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to blog detail page (if needed)
                      },
                      child: Card(
                        elevation: 0,
                        color: AppPalette.secondaryColor.withAlpha(20),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                blog.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppPalette.focusedColor,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    Constants.formatDate(blog.updatedAt),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          fontStyle: FontStyle.italic,
                                          color: AppPalette.textGrey,
                                        ),
                                  ),
                                ],
                              ),
                              const Divider(
                                thickness: 0.5,
                                indent: 20,
                                endIndent: 20,
                              ),
                              Stack(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl: blog.imageUrl,
                                          fit: BoxFit.fill,
                                          placeholder: (context, url) =>
                                              const Center(child: Loader()),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: Wrap(
                                      children: [
                                        if (blog.topics.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Chip(
                                              label: Text(
                                                blog.topics.first,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .copyWith(
                                                      color: AppPalette
                                                          .focusedColor,
                                                    ),
                                              ),
                                              color:
                                                  const WidgetStatePropertyAll(
                                                      AppPalette.transparent),
                                            ),
                                          ),
                                        if (blog.topics.length > 1)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12.0),
                                            child: Chip(
                                              label: Text(
                                                '+${blog.topics.length - 1}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .copyWith(
                                                      color: AppPalette
                                                          .focusedColor,
                                                    ),
                                              ),
                                              color:
                                                  const WidgetStatePropertyAll(
                                                      AppPalette.transparent),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                blog.content,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppPalette.focusedColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 8,
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editBlog(context, blog); // Trigger edit action
                          } else if (value == 'delete') {
                            _deleteBlog(blog.id); // Trigger delete action
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
          if (state is BlogFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final userId = (context.read<AppUserCubit>().state
                              as AppUserLoggedIn)
                          .user
                          .id;
                      context.read<BlogBloc>().add(FetchUserBlogsEvent(userId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('An unexpected error occurred.'));
        },
      ),
    );
  }
}
