import 'package:discover_webtoon/models/webtoon_detail_kakao_model.dart';
import 'package:discover_webtoon/widgets/episode_widget.dart';
import 'package:flutter/material.dart';
import 'package:discover_webtoon/models/webtoon_detail_model.dart';
import 'package:discover_webtoon/models/webtoon_episode_model.dart';
import 'package:discover_webtoon/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/text_styles.dart';

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
  late Future<List<WebtoonEpisodeModel>> episodes;
  late Future<WebtoonDetailKakaoModel> webtoonKakao;
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
      });
    }
  }

  @override
  void initState() {
    super.initState();

    webtoon = ApiService.getToonById(widget.webtoonId);
    episodes = ApiService.getToonEpisodeById(widget.webtoonId);
    webtoonKakao = ApiService.getKakaoToonById(widget.title);

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
        title: Text(widget.title, style: TextStyles.f30W800TextStyle),
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.webtoonId,
              child: Container(
                height: 500,
                width: MediaQuery.of(context).size.width,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: const Color(0xfffcf0f0)),
                child: Image.network(
                  widget.img,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  headers: const {
                    "User-Agent":
                        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (widget.service == 'naver') naverDetail(),
            if (widget.service == 'kakao' || widget.service == 'kakaoPage') kakaoDetail(),
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
                      const Text('작품소개', style: TextStyles.f15W800TextStyle),
                      const SizedBox(height: 10),
                      Text(snapshot.data!.about, style: TextStyles.f15TextStyle),
                      const SizedBox(height: 10),
                      Text('${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: TextStyles.f15TextStyle),
                      const SizedBox(height: 30),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator(color: Colors.green));
                }
              }),
        ),
        FutureBuilder(
            future: episodes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    for (var episode in snapshot.data!.length > 10
                        ? snapshot.data!.sublist(0, 10)
                        : snapshot.data!)
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

  Padding kakaoDetail() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder(
          future: webtoonKakao,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '작가',
                      style: TextStyles.f15W800TextStyle,
                    ),
                    const SizedBox(height: 10),
                    Text(snapshot.data!.author, style: TextStyles.f15TextStyle),
                    const Expanded(child: SizedBox(height: 10)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          final url = Uri.parse(snapshot.data!.url);
                          launchUrl(url);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          "바로보기",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator(color: Colors.green));
            }
          }),
    );
  }
}
