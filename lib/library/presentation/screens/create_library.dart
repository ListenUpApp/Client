import 'package:flutter/material.dart';
import 'package:listenup/core/presentation/ui/widgets/button.dart';
import 'package:listenup/core/presentation/ui/widgets/text_field.dart';
import 'package:listenup/generated/listenup/folder/v1/folder.pb.dart';

import '../../../core/presentation/ui/colors.dart';

class CreateLibraryScreen extends StatelessWidget {
  final TextEditingController _libraryNameController = TextEditingController();
  CreateLibraryScreen({super.key});
  final List<Folder> folders = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ListenUpColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ListenUpColors.gray60),
        title: const Text(
          "Create Library",
          style: TextStyle(fontSize: 20.0, color: ListenUpColors.gray60),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        ListenUpTextField(
                            controller: _libraryNameController,
                            label: "Library Name"),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Text("Folders"),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.add),
                              style: FilledButton.styleFrom(
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                backgroundColor: ListenUpColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.black12,
                        )
                      ],
                    ),
                  ),
                  ListenUpButton(
                      onPressed: () {},
                      text: "Create",
                      enabled: true,
                      pending: false)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
