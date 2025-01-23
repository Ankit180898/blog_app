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
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add your blog"),
        actions: [
          IconButton(
            onPressed: () {
              uploadBlog();
            },
            icon: Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error);
          } else if (state is BlogUploadSuccess) {
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
                GestureDetector(
                  onTap: () {
                    selectImage();
                  },
                  child: image != null
                      ? GestureDetector(
                          onTap: () => selectImage(),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.30,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              )),
                        )
                      : DottedBorder(
                          borderType: BorderType.RRect,
                          color: AppPalette.textGrey,
                          radius: Radius.circular(12),
                          padding: EdgeInsets.all(8),
                          dashPattern: [10, 3],
                          strokeCap: StrokeCap.round,
                          strokeWidth: 2,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.20,
                            child: Center(
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 12,
                                children: [
                                  Icon(
                                    Icons.folder_open_rounded,
                                    color: AppPalette.focusedColor,
                                    size: 48,
                                  ),
                                  Text(
                                    "Select your image",
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          )),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      'Technology',
                      'Business',
                      'Programming',
                      'Entertainment',
                      'Design'
                    ]
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (selectedTopics.contains(e)) {
                                    selectedTopics.remove(e);
                                    setState(() {});
                                    return;
                                  }
                                  selectedTopics.add(e);
                                  setState(() {});
                                },
                                child: Chip(
                                  label: Text(e),
                                  color: selectedTopics.contains(e)
                                      ? const WidgetStatePropertyAll(
                                          AppPalette.textGrey)
                                      : null,
                                  side: BorderSide(
                                    color: AppPalette.textGrey,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                BlogField(hintText: "Blog Title", controller: titleController),
                const SizedBox(height: 16),
                BlogField(
                    hintText: "Blog Content", controller: contentController),
              ],
            ),
          );
        },
      ),
    );
  }
}
