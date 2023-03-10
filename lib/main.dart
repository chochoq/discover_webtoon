import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: const Color(0xFF181818),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'menu',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Hey, NoName',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Welcome back',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                  Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '\$3 233 123',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.amber, borderRadius: BorderRadius.circular(45)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 50,
                          ),
                          child: Text(
                            'Transfer',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(79, 87, 85, 85),
                            borderRadius: BorderRadius.circular(45)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 50,
                          ),
                          child: Text(
                            'Request',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )));
  }
}
