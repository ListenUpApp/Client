import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listenup/auth/data/auth_repository.dart';
import 'package:listenup/auth/presentation/screens/mobile/register_screen.dart';
import 'package:listenup/auth/presentation/screens/mobile/url_screen.dart';
import 'package:listenup/core/data/config/config_service.dart';
import 'package:listenup/core/presentation/ui/colors.dart';
import 'package:listenup/library/data/library_repository.dart';
import 'package:listenup/library/presentation/screens/home_screen.dart';

import 'auth/presentation/bloc/auth/auth_bloc.dart';
import 'auth/presentation/bloc/login/login_bloc.dart';
import 'auth/presentation/bloc/register/register_bloc.dart';
import 'auth/presentation/bloc/url/url_bloc.dart';
import 'auth/presentation/screens/mobile/login_screen.dart';
import 'auth_injection.dart';
import 'core/presentation/ui/theme.dart';
import 'library/presentation/bloc/library_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const ListenUp());
}

class ListenUp extends StatelessWidget {
  const ListenUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: sl(),
            configService: sl(),
            serverRepository: sl(),
          )..add(const AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) => UrlBloc(sl<AuthRepository>(),
              sl<ConfigService>(), context.read<AuthBloc>()),
        ),
        BlocProvider(
          create: (context) =>
              LoginBloc(sl<AuthRepository>(), context.read<AuthBloc>()),
        ),
        BlocProvider(
            create: (context) => RegistrationBloc(
                sl<AuthRepository>(), context.read<AuthBloc>())),
        BlocProvider(
            create: (context) =>
                LibraryBloc(sl<LibraryRepository>(), context.read<AuthBloc>())),
      ],
      child: MaterialApp(
        title: 'ListenUp',
        theme: lightTheme,
        darkTheme: darkTheme,
        home: BlocConsumer<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              previous.runtimeType != current.runtimeType,
          listener: (context, state) {
            print('AuthBloc state changed: $state');
            // You can add navigation logic here if needed
          },
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildScreenForState(state, context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScreenForState(AuthState state, BuildContext context) {
    print('Building screen for state: $state'); // Debug print
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<LibraryBloc>().add(LoadLibraries());
      });
      return const HomeScreen();
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
  }
}
