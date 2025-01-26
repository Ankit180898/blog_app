import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  const BlogCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            BlogDetailPage.route(blog: blog),
          ),
          child: Card(
            elevation: 0,
            color: AppPalette.secondaryColor.withAlpha(20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    blog.title,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppPalette.focusedColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  color:
                                      AppPalette.focusedColor), // Default style
                          children: [
                            TextSpan(
                              text: 'By: ',
                              style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold), // Bold for "By:"
                            ),
                            TextSpan(
                              text: blog.posterName??"Unknown", // Author's name
                              style: TextStyle(
                                decoration: TextDecoration
                                    .underline, // Underline the author's name
                              ), // Style for the author's name
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Text(Constants.formatDate(blog.updatedAt),
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: AppPalette.textGrey)),
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
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: Center(
                          child: Hero(
                            tag:
                                'blog-image-${blog.id}', // Unique tag for the hero animation
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: blog.imageUrl,
                                fit: BoxFit.fill,
                                placeholder: (context, url) =>
                                    Center(child: const Loader()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
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
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Chip(
                                  label: Text(
                                    blog.topics.first,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                            color: AppPalette.focusedColor),
                                  ),
                                  color: WidgetStatePropertyAll(
                                      AppPalette.transparent),
                                ),
                              ),
                            if (blog.topics.length > 1)
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Chip(
                                  label: Text(
                                    '+${blog.topics.length - 1}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                            color: AppPalette.focusedColor),
                                  ),
                                  color: WidgetStatePropertyAll(
                                      AppPalette.transparent),
                                ),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(
                    blog.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: AppPalette.focusedColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            right: 0,
            top: 8,
            child: IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)))
      ],
    );
  }
}
