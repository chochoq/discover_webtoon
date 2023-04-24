import 'package:discover_webtoon/models/webtoon_kakao_model.dart';
import 'package:discover_webtoon/models/webtoon_naver_model.dart';
import 'package:discover_webtoon/screens/detail_screen.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';

class ListScreen extends StatelessWidget {
  final String txt;
  ListScreen({super.key, required this.txt});

  final Future<List<WebtoonNaverModel>> webtoonsNaver = ApiService.getTodaysNaverToons();
  final Future<List<WebtoonKakaoModel>> webtoonsKakao = ApiService.getTodaysKakaoToons('kakao');
  final Future<List<WebtoonKakaoModel>> webtoonsKakaoPage =
      ApiService.getTodaysKakaoToons('kakaoPage');

  @override
  Widget build(BuildContext context) {
    String service = txt;

    late String serviceEng = '';
    late Future webtoonApi;

    if (service == '네이버 웹툰') {
      webtoonApi = webtoonsNaver;
      serviceEng = 'naver';
    } else if (service == '카카페 웹툰') {
      webtoonApi = webtoonsKakaoPage;
      serviceEng = 'kakaoPage';
    } else {
      webtoonApi = webtoonsKakao;
      serviceEng = 'kakao';
    }

    {
      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          title: Text(
            "오늘의 $service ",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Pretendard',
            ),
          ),
          elevation: 0.0,
        ),
        body: SizedBox(
          child: FutureBuilder(
              future: webtoonApi,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var webtoon = snapshot.data![index];

                      return webtoonBox(context, webtoon, serviceEng);
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 15),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }),
        ),
      );
    }
  }

  GestureDetector webtoonBox(BuildContext context, webtoon, String serviceEng) {
    return GestureDetector(
      onTap: () {
        serviceEng == 'naver'
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailScreen(
                        webtoonId: webtoon.id,
                        img: webtoon.thumb,
                        title: webtoon.title,
                        service: serviceEng)))
            : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailScreen(
                        webtoonId: webtoon.id,
                        img: webtoon.img,
                        title: webtoon.title,
                        service: serviceEng)));
      },
      child: Hero(
        tag: webtoon.id,
        child: Row(
          children: [
            Container(
              height: 200,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: const Color(0xfffcf0f0)),
              padding: const EdgeInsets.only(left: 10, right: 6),
              child: Image.network(
                serviceEng == 'naver' ? webtoon.thumb : webtoon.img,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                headers: const {
                  "User-Agent":
                      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                },
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              height: 64,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          webtoon.title,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // const Icon(Icons.favorite_border_outlined, size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
