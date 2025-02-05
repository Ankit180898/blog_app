import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_field.dart';
import 'package:blog_app/features/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> selectedTopics = [];
  File? image;
  final formKey = GlobalKey<FormState>();

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(BlogUpload(
            posterId: posterId,
            title: titleController.text.trim(),
            image: image!,
            content: contentController.text.trim(),
            topics: selectedTopics,
          ));
    } else {
      showSnackbar(
          context, 'Please fill all fields and select at least one topic.');
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Blog"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppPalette.backgroundColor,
        foregroundColor: AppPalette.focusedColor,
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavBar(
                    index: 0), // Navigate to BottomNavBar with index 1
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: Loader());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Upload Section
                  Card(
                    elevation: 0,
                    color: AppPalette.containerColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GestureDetector(
                      onTap: selectImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        color: AppPalette.textGrey,
                        radius: const Radius.circular(12),
                        padding: const EdgeInsets.all(16),
                        dashPattern: const [10, 3],
                        strokeCap: StrokeCap.round,
                        strokeWidth: 2,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: double.infinity,
                          child: Center(
                            child: image == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.image,
                                        color: AppPalette.focusedColor,
                                        size: 48,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Upload a cover image",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppPalette.textGrey,
                                        ),
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Blog Title Field
                  Text(
                    "Blog Title",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppPalette.focusedColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlogField(
                    hintText: "Enter your blog title",
                    controller: titleController,
                  ),
                  const SizedBox(height: 24),

                  // Blog Content Field
                  Text(
                    "Blog Content",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppPalette.focusedColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlogField(
                    hintText: "Write your blog content here",
                    controller: contentController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),

                  // Topics Section
                  Text(
                    "Select Topics",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppPalette.focusedColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Technology',
                      'Business',
                      'Programming',
                      'Entertainment',
                      'Design'
                    ]
                        .map((e) => FilterChip(
                              label: Text(e),
                              selected: selectedTopics.contains(e),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    selectedTopics.add(e);
                                  } else {
                                    selectedTopics.remove(e);
                                  }
                                });
                              },
                              selectedColor:
                                  AppPalette.focusedColor.withAlpha(20),
                              backgroundColor: AppPalette.backgroundColor,
                              labelStyle: TextStyle(
                                color: selectedTopics.contains(e)
                                    ? AppPalette.focusedColor
                                    : AppPalette.textGrey,
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: AppPalette.textGrey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: uploadBlog,
        backgroundColor: AppPalette.focusedColor,
        child: const Icon(Icons.check, color: AppPalette.whiteColor),
      ),
    );
  }
}
