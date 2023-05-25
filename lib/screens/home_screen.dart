import 'package:discover_webtoon/models/webtoon_kakao_model.dart';
import 'package:discover_webtoon/models/webtoon_naver_model.dart';
import 'package:discover_webtoon/screens/list_screen.dart';
import 'package:discover_webtoon/services/api_service.dart';
import 'package:discover_webtoon/widgets/main_thumb_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<String> servicesNameKr = ['네이버 웹툰', '카카오페이지 웹툰', '카카오 웹툰'];
  final List<String> servicesNameEng = ['naver', 'kakaoPage', 'kakao'];

  final Future<List<WebtoonNaverModel>> webtoonsNaver = ApiService.getTodaysNaverToons();
  late Future<List<WebtoonKakaoModel>> webtoonsKakaoPage;
  late Future<List<WebtoonKakaoModel>> webtoonsKakao;

  void initializeWebtoons() {
    webtoonsKakaoPage = ApiService.getTodaysKakaoToons(servicesNameEng[1]);
    webtoonsKakao = ApiService.getTodaysKakaoToons(servicesNameEng[2]);
  }

  int basicListCount = 5;

  @override
  Widget build(BuildContext context) {
    initializeWebtoons();
    initializeDateFormatting('ko_KR', null);

    DateTime now = DateTime.now();
    String dayOfWeek = DateFormat('EEEE', 'ko_KR').format(now);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Image.asset("images/ditoonLogo.png", height: 55),
              ),
              Text(
                "$dayOfWeek에 업데이트 된 웹툰😍",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Pretendard',
                  height: 4,
                ),
              ),
            ],
          ),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
              children: [
                ListBetweenSizeBox(),
                mainNaver(),
                ListBetweenSizeBox(),
                webtoonKakao(webtoonsKakaoPage, servicesNameKr[1]),
                ListBetweenSizeBox(),
                webtoonKakao(webtoonsKakao, servicesNameKr[2]),
              ],
            ),
          ),
        ));
  }

  SizedBox ListBetweenSizeBox() => const SizedBox(height: 20);

  FutureBuilder<List<WebtoonNaverModel>> mainNaver() {
    return FutureBuilder(
      future: webtoonsNaver,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return allListButton(context, snapshot, servicesNameKr[0], makeNaverList);
        }
        return const Center();
      },
    );
  }

  FutureBuilder<List<WebtoonKakaoModel>> webtoonKakao(
      Future<List<WebtoonKakaoModel>> webtoon, String txt) {
    return FutureBuilder(
      future: webtoon,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return allListButton(context, snapshot, txt, makeKakaoList);
        }
        return const Center(child: CircularProgressIndicator(color: Colors.green));
      },
    );
  }

  Widget allListButton(BuildContext context, snapshot, String txt, homeList) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ListScreen(txt: txt)));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  txt,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600),
                ),
                const Icon(Icons.arrow_forward_ios_outlined)
              ],
            ),
          ),
        ),
        homeList(snapshot),
      ],
    );
  }

  dynamic makeNaverList(snapshot) {
    return SizedBox(
      height: 330,
      child: ListView.separated(
        itemCount: basicListCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var webtoon = snapshot.data![index];

          return MainThumbWidget(
            title: webtoon.title,
            thumb: webtoon.thumb,
            id: webtoon.id,
            service: servicesNameEng[0],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 5),
      ),
    );
  }

  dynamic makeKakaoList(AsyncSnapshot<List<WebtoonKakaoModel>> snapshot) {
    return SizedBox(
      height: 500,
      child: ListView.separated(
        itemCount: basicListCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var webtoon = snapshot.data![index];

          return MainThumbWidget(
            title: webtoon.title,
            thumb: webtoon.img,
            id: webtoon.id,
            service: webtoon.service,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 5),
      ),
    );
  }
}
