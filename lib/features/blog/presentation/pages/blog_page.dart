import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/your_blogs_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:blog_app/features/splash/pages/splash_page.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) {
        return const BlogPage();
      });
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
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

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),

            // Logout Button
            TextButton(
              onPressed: () {
                // Call the logoutUser method
                context.read<AuthBloc>().add(AuthLogout());

                // Close the dialog
                Navigator.pop(context);

                // Navigate to the SplashPage or LoginPage
                Navigator.of(context).pushReplacement(SplashPage.route());
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _handleCategorySelection(String selectedValue, Function fetchAllBlogs,
      Function filterBlogsByCategory) {
    if (selectedValue == 'All') {
      // Fetch all blogs if "All" is selected
      fetchAllBlogs();
    } else {
      // Dispatch the filter event
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
        () => context
            .read<BlogBloc>()
            .add(BlogFetchAllBlogs()), // Fetch all blogs
        (category) => context
            .read<BlogBloc>()
            .add(FilterBlogPostsByCategoryEvent(category)), // Filter blogs
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BlogD",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: AppPalette.focusedColor, fontWeight: FontWeight.bold),
        ),
        surfaceTintColor: AppPalette.transparent,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            BlocBuilder<AppUserCubit, AppUserState>(
              builder: (context, state) {
                if (state is AppUserLoggedIn) {
                  return DrawerHeader(
                    decoration: BoxDecoration(
                      color: AppPalette.focusedColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppPalette.whiteColor,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: AppPalette.focusedColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.user.name,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(color: AppPalette.whiteColor),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          state.user.email,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: AppPalette.textGrey),
                        ),
                      ],
                    ),
                  );
                }
                return const DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppPalette.focusedColor,
                  ),
                  child: Text(
                    'Blog Menu',
                    style: TextStyle(
                      color: AppPalette.whiteColor,
                      fontSize: 24,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add New Blog'),
              onTap: () {
                Navigator.pop(context); // Close the drawer

                Navigator.push(context, AddNewBlogPage.route());
              },
            ),
            ListTile(
              leading: const Icon(Icons.drafts),
              title: const Text('Your Blogs'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(context,
                    UserBlogsPage.route()); // Navigate to UserBlogsPage
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                        // If the search query is empty, fetch all blogs
                        context.read<BlogBloc>().add(BlogFetchAllBlogs());
                      } else {
                        // Dispatch the search event
                        context
                            .read<BlogBloc>()
                            .add(SearchBlogPostsEvent(value));
                      }
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showFilterMenu(context); // Show filter menu
                  },
                  icon: const Icon(Icons.filter_list),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Blog List
            BlocConsumer<BlogBloc, BlogState>(
              listener: (context, state) {
                if (state is BlogFailure) {
                  showSnackbar(context, state.error);
                }
              },
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
                          child: ListView.builder(
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            itemCount: state.blogs.length,
                            itemBuilder: (BuildContext context, int index) {
                              // Sort the blogs by updatedAt in descending order
                              final sortedBlogs = state.blogs
                                ..sort((a, b) =>
                                    b.updatedAt.compareTo(a.updatedAt));
                              final blog = sortedBlogs[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: BlogCard(blog: blog),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, AddNewBlogPage.route());
        },
        backgroundColor: AppPalette.focusedColor,
        child: const Icon(Icons.add, color: AppPalette.whiteColor),
      ),
    );
  }
}
