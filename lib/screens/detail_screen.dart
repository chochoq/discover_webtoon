import 'package:discover_webtoon/models/webtoon_detail_kakao_model.dart';
import 'package:discover_webtoon/widgets/episode_widget.dart';
import 'package:flutter/material.dart';
import 'package:discover_webtoon/models/webtoon_detail_model.dart';
import 'package:discover_webtoon/models/webtoon_episode_model.dart';
import 'package:discover_webtoon/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final String title, img, webtoonId, service;
  const DetailScreen(
      {super.key,
      required this.title,
      required this.img,
      required this.webtoonId,
      required this.service});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<WebtoonDetailKakaoModel> webtoonKakao;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;

  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('LikedToons');

    if (likedToons != null) {
      if (likedToons.contains(widget.webtoonId) == true) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      // 앱 초기 실행시
      await prefs.setStringList('LikedToons', []);
    }
  }

  onHeartTap() async {
    final likedToons = prefs.getStringList('LikedToons');
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.webtoonId);
      } else {
        likedToons.add(widget.webtoonId);
      }

      await prefs.setStringList('LikedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
        print('isLiked 눌렀을때 -----$isLiked');
        print(likedToons);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    webtoon = ApiService.getToonById(widget.webtoonId);
    webtoonKakao = ApiService.getKakaoToonById(widget.title);
    episodes = ApiService.getToonEpisodeById(widget.webtoonId);

    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: isLiked
                ? const Icon(Icons.favorite_outlined)
                : const Icon(Icons.favorite_border_outlined),
            onPressed: () => onHeartTap(),
          )
        ],
        backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 30,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w800,
          ),
        ),
        foregroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: widget.webtoonId,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      offset: const Offset(10, 10),
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                child: Image.network(
                  widget.img,
                  // scale: 2.5,
                  headers: const {
                    "User-Agent":
                        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (widget.service == 'naver') naverDetail(),
            if (widget.service == 'kakao' || widget.service == 'kakaoPage')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder(
                    future: webtoonKakao,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '작품소개',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              snapshot.data!.author,
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                            Text(
                              snapshot.data!.url,
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
          ],
        ),
      ),
    );
  }

  Column naverDetail() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder(
              future: webtoon,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '작품소개',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        snapshot.data!.about,
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${snapshot.data!.genre} / ${snapshot.data!.age}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
        FutureBuilder(
            future: episodes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    for (var episode in snapshot.data!)
                      EpisodeWidget(
                        episode: episode,
                        webtoonId: widget.webtoonId,
                      ),
                  ],
                );
              }
              return Container();
            })
      ],
    );
  }

  // Column episodeButton(AsyncSnapshot<List<WebtoonEpisodeModel>> snapshot) {
  //   return
  // }
}
