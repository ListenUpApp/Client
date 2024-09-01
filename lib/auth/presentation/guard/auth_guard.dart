import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/ui/colors.dart';
import '../bloc/auth/auth_bloc.dart';
import '../screens/mobile/login_screen.dart';
import '../screens/mobile/register_screen.dart';
import '../screens/mobile/url_screen.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: ListenUpColors.primary,
              ),
            ),
          );
        } else if (state is AuthServerUrlNotSet) {
          return UrlScreen();
        } else if (state is AuthAuthenticated) {
          return child;
        } else if (state is AuthUnauthenticated) {
          return LoginScreen();
        } else if (state is AuthSetupRequired) {
          return RegisterScreen();
        } else {
          return Scaffold(
            body: Center(
              child: Text('Unexpected state: $state'),
            ),
          );
        }
      },
    );
  }
}
