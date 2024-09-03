import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listenup/core/presentation/ui/widgets/button.dart';
import 'package:listenup/core/presentation/ui/widgets/text_field.dart';
import 'package:listenup/generated/listenup/folder/v1/folder.pb.dart';
import 'package:listenup/library/presentation/widgets/folder_browser.dart';

import '../../../core/presentation/ui/colors.dart';
import '../bloc/create/create_library_bloc.dart';

class CreateLibraryScreen extends StatelessWidget {
  final TextEditingController _libraryNameController = TextEditingController();

  CreateLibraryScreen({super.key});

  final List<Folder> folders = [];

  @override
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
        child: BlocConsumer<CreateLibraryBloc, CreateLibraryState>(
          listener: (context, state) {
            if (state is CreateLibrarySuccess) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20.0),
                        ListenUpTextField(
                          controller: _libraryNameController,
                          label: "Library Name",
                          onTextChanged: (value) {
                            context
                                .read<CreateLibraryBloc>()
                                .add(UpdateLibraryName(value));
                          },
                        ),
                        const SizedBox(height: 40.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Folders",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      insetPadding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 32.0),
                                      child: FolderBrowser(
                                        onFolderSelected: (path) {
                                          // Create a Folder object with the selected path
                                          final selectedFolder = Folder()
                                            ..path = path
                                            ..name = path.split('/').last;
                                          context.read<CreateLibraryBloc>().add(
                                              AddFolderToLibrary(
                                                  selectedFolder));
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.add),
                              style: FilledButton.styleFrom(
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                backgroundColor: ListenUpColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.black12),
                        const SizedBox(height: 8.0),
                        if (state is CreateLibraryLoaded)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.selectedFolders.length,
                            itemBuilder: (context, index) {
                              final folder = state.selectedFolders[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(folder.name),
                                subtitle: Text(folder.path),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: ListenUpColors.primary,
                                    size: 28.0,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<CreateLibraryBloc>()
                                        .add(RemoveFolderFromLibrary(folder));
                                  },
                                ),
                              );
                            },
                          )
                        else
                          const Text("No Folders Added"),
                      ],
                    ),
                  ),
                ),
                if (state is CreateLibraryLoaded)
                  ListenUpButton(
                    onPressed: () => context.read<CreateLibraryBloc>().add(
                          CreateLibrary(
                            _libraryNameController.text.trim(),
                            state.selectedFolders,
                          ),
                        ),
                    text: "Create",
                    enabled: true,
                    pending: false,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
