import 'package:discover_webtoon/screens/detail_screen.dart';
import 'package:flutter/material.dart';

class Webtoon extends StatelessWidget {
  final String title, id, thumb, service;
  const Webtoon(
      {super.key,
      required this.title,
      required this.thumb,
      required this.id,
      required this.service});

  @override
  Widget build(BuildContext context) {
    {
      return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailScreen(webtoonId: id, img: thumb, title: title, service: service)));
          },
          child: service == 'naver'
              ? Hero(
                  tag: id,
                  child: Image.network(
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    thumb,
                    headers: const {
                      "User-Agent":
                          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                    },
                  ),
                )
              : kakaoWidget());
    }
  }

  Column kakaoWidget() {
    return Column(
      children: [
        Hero(
          tag: id,
          child: Container(
            width: 250,
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
              thumb,
              // scale: 2.5,
              headers: const {
                "User-Agent":
                    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
