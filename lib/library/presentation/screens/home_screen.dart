import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                    const Text(
                      "Create One",
                      style: TextStyle(color: ListenUpColors.primary),
                    ),
                  ],
                ),
              );
            } else {
              return const Text("Libraries loaded successfully");
            }
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
