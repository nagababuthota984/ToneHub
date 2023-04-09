import 'package:flutter/material.dart';
import 'package:tonehub/widgets/homePage.dart';

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
          colorSchemeSeed:  const Color(0x002C3091), useMaterial3: true),
      home: const HomePage(title: 'Tone Hub'),
    );
  }
}
