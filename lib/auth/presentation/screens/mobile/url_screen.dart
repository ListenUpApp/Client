import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/asset_paths.dart';
import '../../../../core/presentation/ui/colors.dart';
import '../../../../core/presentation/ui/widgets/button.dart';
import '../../../../core/presentation/ui/widgets/text_field.dart';
import '../../bloc/url/url_bloc.dart';
import '../../bloc/url/url_state.dart';
import '../../widgets/auth_label.dart';
import '../../widgets/gradient_background.dart';

class UrlScreen extends StatelessWidget {
  final TextEditingController _serverUrlController = TextEditingController();

  UrlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ListenUpColors.orangeBackground,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 599) {
            return UrlScreenMobile(
              serverUrlController: _serverUrlController,
            );
          } else {
            return UrlScreenTablet(
              serverUrlController: _serverUrlController,
            );
          }
        },
      ),
    );
  }
}

class UrlScreenMobile extends StatelessWidget {
  final TextEditingController serverUrlController;
  const UrlScreenMobile({super.key, required this.serverUrlController});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
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
                child:
                    BlocConsumer<UrlBloc, UrlState>(listener: (context, state) {
                  if (state is UrlLoadSuccess) {
                  } else if (state is UrlLoadFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                }, builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthLabel(
                        title: "Server URL",
                        label: "Enter the URL of your Server Below",
                      ),
                      ListenUpTextField(
                        controller: serverUrlController,
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
                              serverUrlController.text.trim();
                          context
                              .read<UrlBloc>()
                              .add(SubmitButtonPressed(serverUrlTrimmed));
                        },
                      ),
                    ],
                  );
                }),
              ),
            )),
      )
    ]);
  }
}

class UrlScreenTablet extends StatelessWidget {
  final TextEditingController serverUrlController;
  const UrlScreenTablet({super.key, required this.serverUrlController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ListenUpColors.orangeBackground,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Image(
                width: 150,
                image: AssetImage(AssetPaths.whiteTextColorLogo),
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                constraints: const BoxConstraints(maxWidth: 450),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: BlocConsumer<UrlBloc, UrlState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AuthLabel(
                          title: "Server URL",
                          label: "Enter the URL of your Server Below",
                        ),
                        ListenUpTextField(
                          controller: serverUrlController,
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
                                serverUrlController.text.trim();
                            context
                                .read<UrlBloc>()
                                .add(SubmitButtonPressed(serverUrlTrimmed));
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
