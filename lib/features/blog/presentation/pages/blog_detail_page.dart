import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BlogDetailPage extends StatelessWidget {
  static Route route({required Blog blog}) {
    return MaterialPageRoute(builder: (_) => BlogDetailPage(blog: blog));
  }

  final Blog blog;

  const BlogDetailPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          padding: const EdgeInsets.all(16),
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
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  children: blog.topics
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Chip(
                                label: Text(
                                  e,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: AppPalette.focusedColor,
                                      ),
                                ),
                                color: WidgetStatePropertyAll(
                                    AppPalette.secondaryColor.withAlpha(20))),
                          ))
                      .toList(),
                ),
                Text(Constants.formatDate(blog.updatedAt),
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppPalette.textGrey)),
              ],
            ),
            Text(
              blog.title,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: AppPalette.focusedColor), // Default style
                    children: [
                      TextSpan(
                        text: 'By: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold), // Bold for "By:"
                      ),
                      TextSpan(
                        text: blog.posterName??'Unknown', // Author's name
                        style: TextStyle(
                          decoration: TextDecoration
                              .underline, // Underline the author's name
                        ), // Style for the author's name
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      size: 18,
                      Icons.share_rounded,
                      color: AppPalette.textGrey,
                    ))
              ],
            ),
            const Divider(
              color: AppPalette.textGrey,
            ),
            // Using Text.rich for formatted content
            Text.rich(
              TextSpan(
                children: _formatBlogContent(blog.content, context),
              ),
              style: TextStyle(fontSize: 16),
            ),
          ],
        ));
  }

  List<TextSpan> _formatBlogContent(String content, BuildContext context) {
    // Split the content into parts based on your formatting rules
    // For example, you can split by new lines or specific markers
    List<TextSpan> spans = [];
    List<String> lines = content.split('\n\n'); // Split by new lines

    for (String line in lines) {
      spans.add(TextSpan(
        text: '${line.trim()}\n',
        style: Theme.of(context).textTheme.bodyLarge,
      )); // Add each line as a TextSpan
    }

    return spans;
  }
}
