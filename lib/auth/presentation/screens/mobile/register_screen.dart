import 'package:flutter/material.dart';

import '../../../../core/presentation/ui/widgets/button.dart';
import '../../../../core/presentation/ui/widgets/text_field.dart';
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
      body: CustomScrollView(
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
                        title: "Welcome to ListenUp!",
                        label: "Enter the credentials for the Admin user.",
                      ),
                      ListenUpTextField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        label: "Your Name",
                        onTextChanged: (value) {},
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
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
