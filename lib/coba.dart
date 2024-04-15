import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String text = 'Test';

  void onPressed() {
    setState(() {
      text = 'Test2';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text),
        const Icon(Icons.abc),
        ElevatedButton(onPressed: onPressed, child: Container())
      ],
    );
  }
}
