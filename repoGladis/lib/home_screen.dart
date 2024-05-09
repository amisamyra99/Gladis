
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});
  static const routeNamed= '/home';

  @override
  Widget build(BuildContext context) {
    return  Scaffold( body:
    SafeArea(
      child: Column(
        children: [
          Title(color: Colors.lightBlue, child: const Text('Welcome Page') ),
        ],
      ),
    )
    );
  }
}
