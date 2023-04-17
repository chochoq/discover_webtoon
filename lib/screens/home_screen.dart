import 'package:discover_webtoon/models/webtoon_model.dart';
import 'package:discover_webtoon/services/api_service.dart';
import 'package:discover_webtoon/widgets/webtoon_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
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
              return Column(
                children: [
                  const SizedBox(height: 50),
                  Expanded(child: makeList(snapshot)),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemCount: snapshot.data!.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];

        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 20),
    );
  }
}
