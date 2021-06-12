import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  static const route = '/error-screen';
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FittedBox(
              child: Text(
                'ʕノ•ᴥ•ʔノ ︵ ┻━┻',
                style: Theme.of(context)
                    .textTheme
                    .headline4?.copyWith(fontFamily: ''),
              ),
            ),
            FittedBox(
              child: Text(
                'Error 404',
                style: Theme.of(context)
                    .textTheme
                    .headline4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
