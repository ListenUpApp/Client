import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listenup/auth/presentation/bloc/url/url_bloc.dart';
import 'package:listenup/auth/presentation/widgets/auth_label.dart';
import 'package:listenup/auth/presentation/widgets/gradient_background.dart';
import 'package:listenup/core/presentation/ui/widgets/button.dart';
import 'package:listenup/core/presentation/ui/widgets/text_field.dart';

class UrlScreen extends StatelessWidget {
  final TextEditingController _serverUrlController = TextEditingController();
  UrlScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UrlBloc, UrlState>(
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
                        color: Theme.of(context).cardColor),
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
                              title: "Server Url",
                              label: "Enter the URL of your Server Below",
                            ),
                            ListenUpTextField(
                              controller: _serverUrlController,
                              keyboardType: TextInputType.url,
                              label: "Server URL",
                            ),
                            const SizedBox(height: 50),
                            ListenupButton(
                              text: "Submit",
                              enabled: true,
                              pending: state.isPinging,
                              onPressed: () {
                                final serverUrlTrimmed =
                                    _serverUrlController.text.trim();
                                context
                                    .read<UrlBloc>()
                                    .add(SubmitButtonPressed(serverUrlTrimmed));
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
          listener: (context, state) {}),
    );
  }
}
