import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/asset_paths.dart';
import '../../../../core/presentation/ui/colors.dart';
import '../../../../core/presentation/ui/widgets/button.dart';
import '../../../../core/presentation/ui/widgets/text_field.dart';
import '../../bloc/register/register_bloc.dart';
import '../../widgets/auth_label.dart';
import '../../widgets/gradient_background.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 599) {
            return RegisterScreenMobile(
              nameController: _nameController,
              emailController: _emailController,
              passwordController: _passwordController,
            );
          } else {
            return RegisterScreenTablet(
              nameController: _nameController,
              emailController: _emailController,
              passwordController: _passwordController,
            );
          }
        },
      ),
    );
  }
}

class RegisterScreenMobile extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RegisterScreenMobile(
      {super.key,
      required this.nameController,
      required this.emailController,
      required this.passwordController});

  @override
  Widget build(BuildContext context) {
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
                child: BlocConsumer<RegistrationBloc, RegistrationState>(
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
                          title: "Welcome to ListenUp!",
                          label: "Enter the credentials for the Admin user.",
                        ),
                        ListenUpTextField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          label: "Your Name",
                          onTextChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        ListenUpTextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          label: "Email",
                          onTextChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        ListenUpTextField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          label: "Password",
                          onTextChanged: (value) {},
                        ),
                        const SizedBox(height: 30),
                        ListenupButton(
                          text: "Submit",
                          enabled: true,
                          pending: false,
                          onPressed: () {
                            context.read<RegistrationBloc>().add(
                                  RegistrationSubmitClicked(
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text),
                                );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterScreenTablet extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RegisterScreenTablet(
      {super.key,
      required this.nameController,
      required this.emailController,
      required this.passwordController});

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
                child: BlocConsumer<RegistrationBloc, RegistrationState>(
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
                          title: "Welcome to ListenUp!",
                          label: "Enter the credentials for the Admin user.",
                        ),
                        ListenUpTextField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          label: "Your Name",
                          onTextChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        ListenUpTextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          label: "Email",
                          onTextChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        ListenUpTextField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          label: "Password",
                          onTextChanged: (value) {},
                        ),
                        const SizedBox(height: 30),
                        ListenupButton(
                          text: "Submit",
                          enabled: true,
                          pending: false,
                          onPressed: () {
                            context.read<RegistrationBloc>().add(
                                  RegistrationSubmitClicked(
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text),
                                );
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
