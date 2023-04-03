import 'package:discover_webtoon/models/webtoon_model.dart';
import 'package:discover_webtoon/services/api_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    print(webtoons);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            '오늘의 웹툰',
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Nanum Gothic',
              fontWeight: FontWeight.w800,
            ),
          ),
          foregroundColor: Colors.green,
          elevation: 0,
        ),
        body: FutureBuilder(
          future: webtoons,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const Text('has data');
            }
            return const Text('loading...');
          },
        ));
  }
}
