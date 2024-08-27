import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listenup/auth/presentation/bloc/url/url_bloc.dart';
import 'package:listenup/auth/presentation/widgets/auth_label.dart';
import 'package:listenup/auth/presentation/widgets/gradient_background.dart';
import 'package:listenup/core/presentation/ui/widgets/button.dart';
import 'package:listenup/core/presentation/ui/widgets/text_field.dart';

import '../../bloc/url/url_state.dart';

class UrlScreen extends StatelessWidget {
  final TextEditingController _serverUrlController = TextEditingController();

  UrlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UrlBloc, UrlState>(
        listener: (context, state) {
          if (state is UrlLoadSuccess) {
          } else if (state is UrlLoadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: GradientBackground(),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AuthLabel(
                            title: "Server URL",
                            label: "Enter the URL of your Server Below",
                          ),
                          ListenUpTextField(
                            controller: _serverUrlController,
                            keyboardType: TextInputType.url,
                            label: "Server URL",
                            onTextChanged: (value) {
                              context.read<UrlBloc>().add(UrlChanged(value));
                            },
                          ),
                          const SizedBox(height: 20),
                          if (state is UrlLoadFailure)
                            Text(
                              state.error,
                              style: const TextStyle(color: Colors.red),
                            ),
                          const SizedBox(height: 30),
                          ListenupButton(
                            text: "Submit",
                            enabled: state is! UrlLoading,
                            pending: state is UrlLoading,
                            onPressed: () {
                              final serverUrlTrimmed =
                                  _serverUrlController.text.trim();
                              context
                                  .read<UrlBloc>()
                                  .add(SubmitButtonPressed(serverUrlTrimmed));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
