import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_detail_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogCard extends StatefulWidget {
  final Blog blog;
  final VoidCallback onLike;
  final VoidCallback onUnlike;
  final bool isLiked;
  const BlogCard({
    super.key,
    required this.blog,
    required this.onLike,
    required this.onUnlike,
    required this.isLiked,
  });

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appUserState = context.read<AppUserCubit>().state;
      if (appUserState is AppUserLoggedIn) {
        context.read<BlogBloc>().add(
              CheckIfBlogIsLikedEvent(
                blogId: widget.blog.id,
                userId: appUserState.user.id,
              ),
            );
      }
    });
  }

  bool _isProcessing = false;
  
  void _onLikePressed(bool isLiked) async {
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      final userId = appUserState.user.id;
      context.read<BlogBloc>().add(
            isLiked
                ? UnlikeBlogEvent(blogId: widget.blog.id, userId: userId)
                : LikeBlogEvent(blogId: widget.blog.id, userId: userId),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please log in to like or unlike the blog.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          BlogDetailPage.route(blog: widget.blog),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 12,
                            color: AppPalette.focusedColor.withAlpha(100),
                          ),
                      children: [
                        const TextSpan(text: "In "),
                        TextSpan(
                          text: widget.blog.topics.isNotEmpty
                              ? widget.blog.topics.first
                              : 'Blog',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: " by "),
                        TextSpan(
                          text: widget.blog.posterName ?? "Unknown",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.blog.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppPalette.focusedColor,
                        ),
                  ),
                  Text(
                    widget.blog.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppPalette.focusedColor.withAlpha(150),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        Constants.formatDate(widget.blog.updatedAt),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppPalette.focusedColor.withAlpha(120),
                            ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${calculateReadingTime(widget.blog.content)} min read",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppPalette.focusedColor.withAlpha(120),
                            ),
                      ),
                      const SizedBox(width: 12),
                      BlocBuilder<BlogBloc, BlogState>(
                        builder: (context, state) {
                          bool isLiked =
                              widget.isLiked; // Use `widget.isLiked` here.
                          int likeCount = widget.blog.likesCount;

                          // Update the local UI based on the bloc state
                          if (state is BlogLikedState &&
                              state.blogId == widget.blog.id) {
                            isLiked = true;
                            likeCount++;
                          } else if (state is BlogUnlikeState &&
                              state.blogId == widget.blog.id) {
                            isLiked = false;
                            likeCount--;
                          }
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _onLikePressed(
                                      isLiked); // Trigger like/unlike
                                },
                                child: Icon(
                                  isLiked
                                      ? CupertinoIcons.heart_fill
                                      : CupertinoIcons.heart,
                                  color: isLiked
                                      ? Colors.red
                                      : AppPalette.focusedColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                likeCount.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppPalette.focusedColor
                                          .withAlpha(120),
                                    ),
                              ),
                            ],
                          );
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.ellipsis_vertical),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.blog.imageUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 40.0),
                child: Hero(
                  tag: 'blog-image-${widget.blog.id}',
                  child: CachedNetworkImage(
                    imageUrl: widget.blog.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: Loader()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
