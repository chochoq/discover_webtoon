import 'package:discover_webtoon/models/webtoon_kakao_model.dart';
import 'package:discover_webtoon/models/webtoon_naver_model.dart';
import 'package:discover_webtoon/services/api_service.dart';
import 'package:discover_webtoon/widgets/webtoon_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonNaverModel>> webtoonsNaver = ApiService.getTodaysNaverToons();
  final Future<List<WebtoonKakaoModel>> webtoonsKakao = ApiService.getTodaysKakaoToons('kakao');
  final Future<List<WebtoonKakaoModel>> webtoonsKakaoPage =
      ApiService.getTodaysKakaoToons('kakaoPage');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              Image.asset("images/ditoonLogo.jpg", height: 55),
            ],
          ),
          // const Text(
          //   '오늘의 웹툰',
          //   style: TextStyle(
          //     fontSize: 30,
          //     fontFamily: 'Pretendard',
          //     fontWeight: FontWeight.w800,
          //   ),
          // ),
          foregroundColor: Colors.green,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Text('ddd에 업데이트 된 웹툰'),
              mainNaver(),
              webtoonKakao(webtoonsKakao),
              webtoonKakao(webtoonsKakaoPage),
            ],
          ),
        ));
  }

  FutureBuilder<List<WebtoonKakaoModel>> webtoonKakao(Future<List<WebtoonKakaoModel>> webtoon) {
    return FutureBuilder(
      future: webtoon,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return makeKakaoList(snapshot);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  FutureBuilder<List<WebtoonNaverModel>> mainNaver() {
    return FutureBuilder(
      future: webtoonsNaver,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return makeNaverList(snapshot);
        }
        return const Center();
      },
    );
  }

  dynamic makeNaverList(snapshot) {
    return SizedBox(
      height: 400,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        itemCount: snapshot.data!.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var webtoon = snapshot.data![index];

          return Webtoon(
            title: webtoon.title,
            thumb: webtoon.thumb,
            id: webtoon.id,
            service: 'naver',
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 20),
      ),
    );
  }

  dynamic makeKakaoList(AsyncSnapshot<List<WebtoonKakaoModel>> snapshot) {
    return SizedBox(
      height: 400,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        itemCount: snapshot.data!.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var webtoon = snapshot.data![index];

          return Webtoon(
            title: webtoon.title,
            thumb: webtoon.img,
            id: webtoon.id,
            service: webtoon.service,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 20),
      ),
    );
  }
}
