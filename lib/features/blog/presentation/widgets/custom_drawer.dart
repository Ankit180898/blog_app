import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/your_blogs_page.dart';
import 'package:blog_app/features/navigation/navigation.dart';
import 'package:blog_app/features/settings/presentation/pages/settings_page.dart';
import 'package:blog_app/features/splash/pages/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor:
          AppPalette.focusedColor.withAlpha(250), // Dark theme background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80), // Space from top
          BlocBuilder<AppUserCubit, AppUserState>(
            builder: (context, state) {
              if (state is AppUserLoggedIn) {
                return _buildUserProfile(state.user);
              } else {
                return _buildGuestHeader();
              }
            },
          ),
          const Divider(color: Colors.grey, thickness: 0.5),
          _buildDrawerItem(Icons.add, "Add new article", () {
            Navigator.pop(context); // Close the drawer
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavBar(
                    index: 1), // Navigate to BottomNavBar with index 1
              ),
            );
          }),
          _buildDrawerItem(Icons.article, "Your articles", () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavBar(
                    index: 2), // Navigate to BottomNavBar with index 1
              ),
            );
          }),
          // _buildDrawerItem(Icons.timeline, "Your activity", () {
          //   // Navigate to activity page (if you have one)
          //   Navigator.pop(context);
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => BottomNavBar(
          //           index: 2), // Navigate to BottomNavBar with index 1
          //     ),
          //   );
          // }),
          // _buildDrawerItem(Icons.subscriptions, "Your subscriptions", () {
          //   // Navigate to subscriptions page (if you have one)
          //   Navigator.pop(context);
          // }),
          _buildDrawerItem(Icons.settings, "Settings", () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavBar(
                    index: 3), // Navigate to BottomNavBar with index 1
              ),
            );
          }),
          // _buildDrawerItem(Icons.logout, "Log out", () {
          //   _logout(context);
          // }),
        ],
      ),
    );
  }

  /// **Widget for displaying logged-in user profile**
  Widget _buildUserProfile(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: AppPalette.textGrey),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// **Widget for guest header (if user not logged in)**
  Widget _buildGuestHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 40, color: Colors.black),
          ),
          SizedBox(height: 16),
          Text(
            "Guest User",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            "Sign in to access features",
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  /// **Drawer item builder**
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
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
}
