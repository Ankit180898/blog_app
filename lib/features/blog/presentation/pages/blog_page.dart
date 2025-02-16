import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  void _onScroll() {
    final state = context.read<BlogBloc>().state;
    if (state is BlogsDisplaySuccess &&
        !state.hasReachedEnd &&
        !_isFetching &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100) {
      _isFetching = true;
      context.read<BlogBloc>().add(FetchBlogsPaginatedEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleCategorySelection(String selectedValue) {
    if (selectedValue == 'All') {
      context.read<BlogBloc>().add(BlogFetchAllBlogs());
    } else {
      context
          .read<BlogBloc>()
          .add(FilterBlogPostsByCategoryEvent(selectedValue));
    }
  }

  Future<void> _showFilterMenu(BuildContext context) async {
    final selectedValue = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 150,
        kToolbarHeight + 10,
        0,
        0,
      ),
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
      _handleCategorySelection(selectedValue);
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: CupertinoSearchTextField(
                    controller: _searchController,
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
            Expanded(
              child: BlocBuilder<BlogBloc, BlogState>(
                buildWhen: (previous, current) =>
                    current is BlogsDisplaySuccess ||
                    current is BlogLikedState ||
                    current is BlogUnlikeState ||
                    current is BlogLoading,
                builder: (context, state) {
                  if (state is BlogLoading) {
                    return const Center(child: Loader());
                  }

                  if (state is BlogsDisplaySuccess) {
                    _isFetching = false;

                    /// Get the current user ID from AppUserCubit
                    final currentUserId =
                        context.read<AppUserCubit>().state is AppUserLoggedIn
                            ? (context.read<AppUserCubit>().state
                                    as AppUserLoggedIn)
                                .user
                                .id
                            : '';

                    return state.blogs.isEmpty
                        ? Center(
                            child: DotLottieLoader.fromAsset(
                              "assets/images/empty_state.lottie",
                              frameBuilder: (ctx, dotlottie) {
                                return dotlottie != null
                                    ? Lottie.memory(
                                        dotlottie.animations.values.single)
                                    : const CircularProgressIndicator();
                              },
                            ),
                          )
                        : ListView.separated(
                            controller: _scrollController,
                            itemCount: state.blogs.length,
                            itemBuilder: (context, index) {
                              final blog = state.blogs[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: BlogCard(
                                  key: ValueKey(blog
                                      .id), // Use a unique key for each blog
                                  blog: blog,
                                  onLike: () {
                                    context.read<BlogBloc>().add(LikeBlogEvent(
                                          blogId: blog.id,
                                          userId:
                                              currentUserId, // Pass the current user ID
                                        ));
                                  },
                                  onUnlike: () {
                                    context
                                        .read<BlogBloc>()
                                        .add(UnlikeBlogEvent(
                                          blogId: blog.id,
                                          userId:
                                              currentUserId, // Pass the current user ID
                                        ));
                                  },
                                  isLiked: blog.isLiked,
                                ),
                              );
                            },
                            separatorBuilder: (_, __) => Divider(
                              color: AppPalette.textGrey,
                              thickness: 0.5,
                            ),
                          );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
