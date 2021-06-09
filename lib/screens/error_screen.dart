import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  static const route = '/error-screen';
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Text(
          'Error',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
