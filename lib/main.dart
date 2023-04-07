import 'package:flutter/material.dart';
import 'package:tonehub/widgets/homepage.dart';

void main() {
  runApp(const ToneHub());
}

class ToneHub extends StatelessWidget {
  const ToneHub({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const HomePage(title: 'Tone Hub'),
    );
  }
}
