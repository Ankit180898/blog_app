import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:blog_app/features/blog/presentation/widgets/custom_drawer.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleCategorySelection(String selectedValue, Function fetchAllBlogs,
      Function filterBlogsByCategory) {
    if (selectedValue == 'All') {
      fetchAllBlogs();
    } else {
      filterBlogsByCategory(selectedValue);
    }
  }

  void _showFilterMenu(BuildContext context) async {
    final selectedValue = await showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: Constants.topics.map((String category) {
        return PopupMenuItem<String>(
          value: category,
          child: Text(
            category,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: AppPalette.focusedColor,
                ),
          ),
        );
      }).toList(),
    );

    if (selectedValue != null) {
      _handleCategorySelection(
        selectedValue,
        () => context.read<BlogBloc>().add(BlogFetchAllBlogs()),
        (category) => context
            .read<BlogBloc>()
            .add(FilterBlogPostsByCategoryEvent(category)),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BlogD",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: AppPalette.focusedColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        surfaceTintColor: AppPalette.transparent,
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: CupertinoSearchTextField(
                    controller: _searchController,
                    autofocus: false,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        context.read<BlogBloc>().add(BlogFetchAllBlogs());
                      } else {
                        context
                            .read<BlogBloc>()
                            .add(SearchBlogPostsEvent(value));
                      }
                    },
                  ),
                ),
                IconButton(
                  onPressed: () => _showFilterMenu(context),
                  icon: const Icon(Icons.filter_list),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Blog List
            BlocBuilder<BlogBloc, BlogState>(
              buildWhen: (previous, current) =>
                  previous != current, // Only rebuild when state changes

              builder: (context, state) {
                if (state is BlogLoading) {
                  return const Loader();
                }
                if (state is BlogsDisplaySuccess) {
                  return state.blogs.isEmpty
                      ? Center(
                          child: DotLottieLoader.fromAsset(
                              "assets/images/empty_state.lottie",
                              frameBuilder: (ctx, dotlottie) {
                            if (dotlottie != null) {
                              return Lottie.memory(
                                  dotlottie.animations.values.single);
                            } else {
                              return Container();
                            }
                          }),
                        )
                      : Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            cacheExtent: 500, // Preload content to reduce lag

                            padding: EdgeInsets.zero,
                            itemCount: state.blogs.length,
                            itemBuilder: (context, index) {
                              final blog = state.blogs[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: BlogCard(
                                  key: ValueKey(blog.id), // Use a unique key
                                  blog: blog,
                                  
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                color: AppPalette.textGrey,
                                thickness: 0.5,
                              );
                            },
                          ),
                        );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
