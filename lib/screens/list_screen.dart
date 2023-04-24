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

    late String serviceName = '';
    late Future webtoonApi;
    if (service == 'naver' || service == '네이버 웹툰') {
      webtoonApi = webtoonsNaver;
      serviceName = 'naver';
      service == '네이버 웹툰';
    } else if (service == 'kakaoPage') {
      webtoonApi = webtoonsKakaoPage;
      service = '카카페 웹툰';
      serviceName == 'kakaoPage';
    } else {
      webtoonApi = webtoonsKakao;
      service = '카카오 웹툰';
      serviceName == 'kakao';
    }

    {
      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          title: Text(
            "오늘의 $service",
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

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                      webtoonId: webtoon.id,
                                      img: webtoon.thumb,
                                      title: webtoon.title,
                                      service: serviceName)));
                        },
                        child: Hero(
                          tag: webtoon.id,
                          child: Row(
                            children: [
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xfffcf0f0)),
                                padding: const EdgeInsets.only(left: 10, right: 6),
                                child: Image.network(
                                  webtoon.thumb,
                                  height: 300,
                                  scale: 0.5,
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
                                        const Icon(Icons.favorite_border_outlined, size: 20),
                                      ],
                                    ),
                                    if (serviceName != 'naver')
                                      Column(
                                        children: const [
                                          SizedBox(height: 6),
                                          Opacity(
                                            opacity: 0.50,
                                            child: Text(
                                              'webtoon',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Pretendard",
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
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
}
