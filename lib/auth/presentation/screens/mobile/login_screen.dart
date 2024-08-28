import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/asset_paths.dart';
import '../../../../core/presentation/ui/colors.dart';
import '../../../../core/presentation/ui/widgets/button.dart';
import '../../../../core/presentation/ui/widgets/text_field.dart';
import '../../bloc/login/login_bloc.dart';
import '../../widgets/auth_label.dart';
import '../../widgets/gradient_background.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 599) {
            return LoginScreenMobile(
                emailController: _emailController,
                passwordController: _passwordController);
          } else {
            return LoginScreenTablet(
              emailController: _emailController,
              passwordController: _passwordController,
            );
          }
        },
      ),
    );
  }
}

class LoginScreenMobile extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginScreenMobile(
      {super.key,
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
                child: BlocConsumer<LoginBloc, LoginState>(
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
                          title: "Login",
                          label: "Enter your credentials below",
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
                            context.read<LoginBloc>().add(
                                  LoginSubmitClicked(
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
        )
      ],
    );
  }
}

class LoginScreenTablet extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const LoginScreenTablet(
      {super.key,
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
              SvgPicture.asset(
                width: 150,
                AssetPaths.blackTextColorLogo,
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
                child: BlocConsumer<LoginBloc, LoginState>(
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
                          title: "Login",
                          label: "Enter your credentials below",
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
                            context.read<LoginBloc>().add(
                                  LoginSubmitClicked(
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
