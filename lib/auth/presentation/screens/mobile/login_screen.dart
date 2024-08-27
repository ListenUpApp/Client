import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listenup/auth/presentation/bloc/login/login_bloc.dart';

import '../../../../core/presentation/ui/widgets/button.dart';
import '../../../../core/presentation/ui/widgets/text_field.dart';
import '../../widgets/auth_label.dart';
import '../../widgets/gradient_background.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          // TODO: implement listener
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
                            title: "Login",
                            label: "Enter your credentials below",
                          ),
                          const SizedBox(height: 20),
                          ListenUpTextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            label: "Email",
                            onTextChanged: (value) {},
                          ),
                          const SizedBox(height: 20),
                          ListenUpTextField(
                            controller: _passwordController,
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
                              context.read<LoginBloc>().add(LoginSubmitClicked(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text));
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
