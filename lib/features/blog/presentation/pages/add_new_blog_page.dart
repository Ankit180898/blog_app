import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_field.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

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
            onPressed: () {},
            icon: Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          DottedBorder(
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
          BlogField(hintText: "Blog Content", controller: contentController),
        ],
      ),
    );
  }
}
