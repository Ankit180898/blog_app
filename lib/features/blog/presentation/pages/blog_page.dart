import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
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
        actions: [],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppPalette.focusedColor, // Set your desired header color
              ),
              child: Text(
                'Blog Menu',
                style: TextStyle(
                  color: AppPalette.whiteColor, // Set text color for header
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Handle navigation to Home
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add New Blog'),
              onTap: () {
                Navigator.push(context, AddNewBlogPage.route());
              },
            ),
            ListTile(
              leading: Icon(Icons.drafts),
              title: Text('Your Blogs'),
              onTap: () {
                Navigator.pop(context); // Close the drawer

                // Navigator.push(context, AddNewBlogPage.route());
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle logout
                Navigator.pop(context); // Close the drawer
              },
            ),
            // Add more ListTiles for additional menu items
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context, AddNewBlogPage.route());
      //   },
      //   child: const Icon(
      //     CupertinoIcons.add,
      //     color: AppPalette.whiteColor,
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 12.0,
          children: [
            CupertinoSearchTextField(
              onChanged: (value) {
                // context.read<BlogBloc>().add(BlogSearch(value));
              },
            ),
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
                      ?

                      ///Simple .Lottie Animation
                      DotLottieLoader.fromAsset("assets/empty_state.lottie",
                          frameBuilder: (ctx, dotlottie) {
                          if (dotlottie != null) {
                            return Lottie.memory(
                                dotlottie.animations.values.single);
                          } else {
                            return Container();
                          }
                        })
                      : Expanded(
                          child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemCount: state.blogs.length,
                          itemBuilder: (BuildContext context, int index) {
                            // Sort the blogs by updatedAt in descending order
                            final sortedBlogs = state.blogs
                              ..sort(
                                  (a, b) => b.updatedAt.compareTo(a.updatedAt));
                            final blog = sortedBlogs[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: BlogCard(blog: blog),
                            );
                          },
                        ));
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
