import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int count = 0;
  List<int> num = [];

  @override
  Widget build(BuildContext context) {
    void onClicked() {
      setState(() {
        // count++;
        num.add(num.length);
      });
      // print(count);
      // print(num);
    }

    return MaterialApp(
      home: Scaffold(
          body: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '클릭 Count',
            style: TextStyle(fontSize: 30),
          ),
          // Text('$count'),
          for (var n in num) Text('$n'),
          ElevatedButton(
            onPressed: onClicked,
            child: const Text('눌러'),
          ),
        ],
      ))),
    );
  }
}
