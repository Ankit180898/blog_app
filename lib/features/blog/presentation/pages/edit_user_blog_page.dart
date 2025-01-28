import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_field.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditUserBlogPage extends StatefulWidget {
  final String blogId;
  final String initialTitle;
  final String initialContent;
  final String? initialImage;
  final List<String> initialTopics;

  static route({
    required String blogId,
    required String initialTitle,
    required String initialContent,
    required String? initialImage,
    required List<String> initialTopics,
  }) =>
      MaterialPageRoute(
        builder: (context) => EditUserBlogPage(
          blogId: blogId,
          initialTitle: initialTitle,
          initialContent: initialContent,
          initialImage: initialImage,
          initialTopics: initialTopics,
        ),
      );

  const EditUserBlogPage({
    super.key,
    required this.blogId,
    required this.initialTitle,
    required this.initialContent,
    required this.initialImage,
    required this.initialTopics,
  });

  @override
  State<EditUserBlogPage> createState() => _EditUserBlogPageState();
}

class _EditUserBlogPageState extends State<EditUserBlogPage> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late List<String> selectedTopics;
  String? imageUrl; // Existing image URL
  File? newImage; // New image file to upload
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    contentController = TextEditingController(text: widget.initialContent);
    selectedTopics = List.from(widget.initialTopics);
    imageUrl = widget.initialImage; // Initialize with the existing image URL
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        newImage = pickedImage; // Store the new image file
        imageUrl = null; // Clear the existing image URL
      });
    }
  }

  void updateBlog() {
    if (formKey.currentState!.validate() && selectedTopics.isNotEmpty) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
            EditBlogEvent(
              id: widget.blogId,
              title: titleController.text.trim(),// Pass the existing image URL (if no new image)
              posterId: posterId,
              content: contentController.text.trim(),
              topics: selectedTopics, 
              image: newImage,
            ),
          );
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
        title: const Text("Edit Blog"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppPalette.backgroundColor,
        foregroundColor: AppPalette.focusedColor,
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error);
          } else if (state is BlogEditSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(
              child: Loader(),
            );
          }
          return Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
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
                          child: newImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    newImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : imageUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        imageUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                AppPalette.focusedColor.withOpacity(0.2),
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: updateBlog,
        backgroundColor: AppPalette.focusedColor,
        child: const Icon(Icons.check, color: AppPalette.whiteColor),
      ),
    );
  }
}