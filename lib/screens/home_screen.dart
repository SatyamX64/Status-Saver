import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const route = '/home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Home',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
