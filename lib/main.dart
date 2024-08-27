import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listenup/auth/data/auth_repository.dart';
import 'package:listenup/auth/presentation/screens/mobile/url_screen.dart';
import 'package:listenup/core/data/config/config_service.dart';

import 'auth/presentation/bloc/login/login_bloc.dart';
import 'auth/presentation/bloc/register/register_bloc.dart';
import 'auth/presentation/bloc/url/url_bloc.dart';
import 'auth_injection.dart';
import 'core/presentation/ui/theme.dart';

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
        BlocProvider(
            create: (context) =>
                UrlBloc(sl<AuthRepository>(), sl<ConfigService>())),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(create: (context) => RegistrationBloc()),
      ],
      child: MaterialApp(
        title: 'ListenUp',
        theme: lightTheme,
        darkTheme: darkTheme,
        home: UrlScreen(),
      ),
    );
  }
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("ListenUp"),
      ),
    );
  }
}
