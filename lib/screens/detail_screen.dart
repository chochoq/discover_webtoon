import 'package:discover_webtoon/widgets/episode_widget.dart';
import 'package:flutter/material.dart';
import 'package:discover_webtoon/models/webtoon_detail_model.dart';
import 'package:discover_webtoon/models/webtoon_episode_model.dart';
import 'package:discover_webtoon/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;
  const DetailScreen({super.key, required this.title, required this.thumb, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;

  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('LikedToons');

    if (likedToons != null) {
      if (likedToons.contains(widget.id) == true) {
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
      print('isLiked눌렀을떄 온태배배배 ---$isLiked');
      if (isLiked) {
        print('11111');
        likedToons.remove(widget.id);
      } else {
        print('222');
        likedToons.add(widget.id);
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

    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getToonEpisodeById(widget.id);

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
            fontFamily: 'Nanum Gothic',
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
              tag: widget.id,
              child: Container(
                // width: 250,
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
                  widget.thumb,
                  // scale: 2.5,
                  headers: const {
                    "User-Agent":
                        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
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
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            snapshot.data!.about,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${snapshot.data!.genre} / ${snapshot.data!.age}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    } else {
                      return const Text("없ㅇㅁ");
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
                            webtoonId: widget.id,
                          ),
                      ],
                    );
                  }
                  return Container();
                })
          ],
        ),
      ),
    );
  }

  // Column episodeButton(AsyncSnapshot<List<WebtoonEpisodeModel>> snapshot) {
  //   return
  // }
}
