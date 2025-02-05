// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blog_app/features/blog/presentation/pages/your_blogs_page.dart';
import 'package:flutter/material.dart';

import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/settings/presentation/pages/settings_page.dart';

class BottomNavBar extends StatefulWidget {
  final int? index;
  const BottomNavBar({
    super.key,
    this.index,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _selectedIndex;

  // List of pages corresponding to each navigation item
  final List<Widget> _pages = [
    const BlogPage(), // Home page
    const AddNewBlogPage(), // Add page
    const UserBlogsPage(), // Activity page
    const SettingsPage(), // Profile page
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index ?? 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        currentIndex: _selectedIndex,
        backgroundColor: AppPalette.whiteColor,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppPalette.focusedColor, // Customize as needed
        unselectedItemColor: Colors.grey, // Customize as needed
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
