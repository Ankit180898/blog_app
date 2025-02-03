import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/splash/pages/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const SettingsPage());
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: AppBar(
          backgroundColor: AppPalette.secondaryColor.withAlpha(20),
          title: Text(
            "Settings",
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppPalette.focusedColor,
                ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildSectionHeader(context, "Account",
                      "Manage your account and profile settings"),
                  _buildListTileSection(
                    context,
                    [
                      _buildListTile(
                        icon: CupertinoIcons.person,
                        title: 'Edit Profile',
                        onTap: () {
                          // Handle account action
                        },
                      ),
                      _buildListTile(
                        icon: CupertinoIcons.bell,
                        title: 'Notifications',
                        onTap: () {
                          // Handle notifications action
                        },
                      ),
                      _buildListTile(
                        icon: CupertinoIcons.delete_simple,
                        title: 'Delete Account',
                        onTap: () {
                          // Handle delete account action
                          _deleteAccount(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSectionHeader(context, "Feedback", "Help us improve"),
                  _buildListTileSection(
                    context,
                    [
                      _buildListTile(
                        icon: Icons.error_outline_rounded,
                        title: 'Report a bug',
                        onTap: () {
                          // Handle report a bug action
                        },
                      ),
                      _buildListTile(
                        icon: CupertinoIcons.paperplane,
                        title: 'Send feedback',
                        onTap: () {
                          // Handle send feedback action
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: _buildListTileSection(
              context,
              [
                _buildListTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    _logout(context);
                    // Handle report a bug action
                  },
                ),
              ],
            ),
          ),
          _buildMadeByText(context),
        ],
      ),
    );
  }

  // Reusable widget for section headers
  Widget _buildSectionHeader(
      BuildContext context, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppPalette.focusedColor,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppPalette.textGrey,
              ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // Reusable widget for list tile sections
  Widget _buildListTileSection(BuildContext context, List<Widget> tiles) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: tiles,
    );
  }

  // Reusable widget for list tiles
  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  // Widget for "Made by Ankit" text
  Widget _buildMadeByText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Center(
        child: GestureDetector(
          onTap: () async {
            const url =
                "https://ankitdev18.netlify.app/"; // Replace with your portfolio link
            if (await canLaunchUrl(
              Uri.parse(url),
            )) {
              await launchUrl(
                Uri.parse(url),
              );
            } else {
              showSnackbar(context, "Couldn't launch $url");
            }
          },
          child: RichText(
            text: TextSpan(
              text: 'Made by ',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: AppPalette.focusedColor),
              children: [
                TextSpan(
                  text: 'Ankit',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteAccount(BuildContext context) {
    final userId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action is irreversible.'),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),

            // Delete Button
            TextButton(
              onPressed: () {
                // Dispatch the delete event with userId
                context.read<AuthBloc>().add(AuthDeleteUser(userId: userId));

                // Close the dialog
                Navigator.pop(context);

                // Navigate to the SplashPage or LoginPage
                Navigator.of(context).pushReplacement(SplashPage.route());
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Highlight delete button
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
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
