import 'package:discover_webtoon/widgets/button.dart';
import 'package:discover_webtoon/widgets/currency_card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Color backBlack = const Color(0xFF1F2123);
    return MaterialApp(
        home: Scaffold(
            backgroundColor: const Color(0xFF181818),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 70),
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
                            textOpacity('Welcome back', 18)
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    textOpacity('Total Balance', 22),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Button(
                          buttonColor: Colors.amber,
                          text: 'Transfer',
                          textColor: Colors.black,
                        ),
                        Button(buttonColor: backBlack, text: 'Request', textColor: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Wallets',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        textOpacity('view all', 18),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const CurrencyCard(
                      order: 1,
                      name: 'Euro',
                      icon: Icons.euro_outlined,
                      code: 'EUR',
                      amount: '2 233',
                      isInverted: false,
                    ),
                    const CurrencyCard(
                      order: 2,
                      name: 'Bitcoin',
                      icon: Icons.currency_bitcoin_outlined,
                      code: 'BTC',
                      amount: '2 233',
                      isInverted: true,
                    ),
                    const CurrencyCard(
                      order: 3,
                      name: 'Dollar',
                      icon: Icons.attach_money_outlined,
                      code: 'EUR',
                      amount: '2 233',
                      isInverted: false,
                    ),
                  ],
                ),
              ),
            )));
  }

  Text textOpacity(String text, double size) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: size,
      ),
    );
  }
}
