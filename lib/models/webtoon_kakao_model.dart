class WebtoonKakaoModel {
  final String title, img, service, id;

  WebtoonKakaoModel.fromJson(Map<dynamic, dynamic> json)
      : title = json['title'],
        img = json['img'],
        id = json['_id'],
        service = json['service'];
}
