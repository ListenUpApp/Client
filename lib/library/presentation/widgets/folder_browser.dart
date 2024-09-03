import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listenup/core/presentation/ui/colors.dart';
import 'package:listenup/core/presentation/ui/widgets/button.dart';

import '../bloc/create/create_library_bloc.dart';

typedef FolderPathCallback = void Function(String path);

class FolderBrowser extends StatefulWidget {
  final FolderPathCallback onFolderSelected;
  const FolderBrowser({super.key, required this.onFolderSelected});

  @override
  State<FolderBrowser> createState() => _FolderBrowserState();
}

class _FolderBrowserState extends State<FolderBrowser> {
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      // Trigger initial load
      context.read<CreateLibraryBloc>().add(const LoadDirectories("/", 0));
      _isInitialized = true;
    }

    return BlocConsumer<CreateLibraryBloc, CreateLibraryState>(
      listener: (context, state) {
        // TODO: implement listener if needed
      },
      builder: (context, state) {
        if (state is CreateLibraryLoaded) {
          final currentPath =
              state.pathHistory.isNotEmpty ? state.pathHistory.last : "/";
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Select Folder",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Expanded(child: Container()),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close))
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      onPressed: () =>
                          context.read<CreateLibraryBloc>().add(NavigateBack()),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: Text(
                        state.pathHistory.join(' / '),
                        style: Theme.of(context).textTheme.labelMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.currentFolders.length,
                    itemBuilder: (context, index) {
                      final item = state.currentFolders[index];
                      return ListTile(
                        onTap: () {
                          context.read<CreateLibraryBloc>().add(
                                LoadDirectories(item.path, item.level),
                              );
                        },
                        leading: const Icon(
                          Icons.folder,
                          color: ListenUpColors.primary,
                        ),
                        title: Text(item.name),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                ListenUpButton(
                  onPressed: () => widget.onFolderSelected(currentPath),
                  text: "Select Current Folder",
                  enabled: true,
                  pending: false,
                ),
              ],
            ),
          );
        } else if (state is CreateLibraryError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }
      },
    );
  }
}
