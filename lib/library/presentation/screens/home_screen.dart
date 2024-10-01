import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listenup/library/presentation/screens/create_library.dart';

import '../../../core/presentation/ui/colors.dart';
import '../bloc/library_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          if (state is LibraryInitial || state is LibraryLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: ListenUpColors.primary,
              ),
            );
          }
          if (state is LibraryError) {
            return const Center(
              child: Text("Error loading libraries"),
            );
          }
          if (state is LibraryLoaded) {
            if (state.availableLibraries.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "No Libraries Found",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CreateLibraryScreen(),
                        ),
                      ),
                      child: const Text(
                        "Create One",
                        style: TextStyle(color: ListenUpColors.primary),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text(
                    "No books found, add some to the directory to continue"),
              );
            }
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
