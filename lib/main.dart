import 'package:flutter/material.dart';

void main() {
  runApp(const ListenUp());
}

class ListenUp extends StatelessWidget {
  const ListenUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListenUp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Root(),
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
    ));
  }
}
