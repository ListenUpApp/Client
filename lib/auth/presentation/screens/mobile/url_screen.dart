import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listenup/auth/presentation/bloc/url/url_bloc.dart';
import 'package:listenup/auth/presentation/widgets/gradient_background.dart';

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
                              Text(
                                "Server URL",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                'Enter the path to your server:',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(
                                height: 38,
                              ),
                              Text(
                                'Server URL',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: _serverUrlController,
                                decoration: const InputDecoration(
                                  label: Text('Server URL'),
                                ),
                              ),
                              const SizedBox(height: 50),
                              TextButton(
                                onPressed: () {
                                  final serverUrlTrimmed =
                                      _serverUrlController.text.trim();
                                  context.read<UrlBloc>().add(
                                      SubmitButtonPressed(serverUrlTrimmed));
                                },
                                child: const Text('Submit'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
              ],
            );
          },
          listener: (context, state) {}),
    );
  }
}
