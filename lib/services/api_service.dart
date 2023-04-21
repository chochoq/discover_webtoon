import 'dart:convert';

import 'package:discover_webtoon/models/webtoon_detail_kakao_model.dart';
import 'package:discover_webtoon/models/webtoon_detail_model.dart';
import 'package:discover_webtoon/models/webtoon_episode_model.dart';
import 'package:discover_webtoon/models/webtoon_kakao_model.dart';
import 'package:discover_webtoon/models/webtoon_naver_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApiService {
  static String baseNaverUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
  static String baseKakaoUrl = "https://korea-webtoon-api.herokuapp.com";
  static String today = "today";

  //오늘의 웹툰 네이버
  static Future<List<WebtoonNaverModel>> getTodaysNaverToons() async {
    List<WebtoonNaverModel> webtoonIstances = [];
    final url = Uri.parse('$baseNaverUrl/$today');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);

      for (var webtoon in webtoons) {
        webtoonIstances.add(WebtoonNaverModel.fromJson(webtoon));
      }

      return webtoonIstances;
    }
    throw Error();
  }

  //오늘의 웹툰 카카오
  static Future<List<WebtoonKakaoModel>> getTodaysKakaoToons(String service) async {
    late var now = DateTime.now();
    String updateDay = '';
    updateToday() {
      updateDay = DateFormat('EEEE').format(now).substring(0, 3).toLowerCase();
    }

    updateToday();

    List<WebtoonKakaoModel> webtoonIstances = [];

    //kakao , kakaoPage
    final url = Uri.parse('$baseKakaoUrl/?service=$service&updateDay=$updateDay');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body)["webtoons"];

      for (var webtoon in webtoons) {
        if (webtoon["img"].startsWith('//')) {
          webtoon["img"] = webtoon["img"].replaceRange(0, 2, 'https://');
        }
        webtoonIstances.add(WebtoonKakaoModel.fromJson(webtoon));
      }

      return webtoonIstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse('$baseNaverUrl/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      print(webtoon);
      return WebtoonDetailModel.fromJSON(webtoon);
    }
    throw Error();
  }

  static Future<WebtoonDetailKakaoModel> getKakaoToonById(String title) async {
    Uri url = Uri.parse('$baseKakaoUrl/search?keyword=$title');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);

      print(webtoon['webtoons'][0]);

      return WebtoonDetailKakaoModel.fromJson(webtoon['webtoons'][0]);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getToonEpisodeById(String id) async {
    final url = Uri.parse('$baseNaverUrl/$id/episodes');

    final response = await http.get(url);

    List<WebtoonEpisodeModel> episodesInstance = [];

    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodesInstance.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstance;
    }
    throw Error();
  }
}
