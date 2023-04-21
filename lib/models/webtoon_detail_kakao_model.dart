class WebtoonDetailKakaoModel {
  final String title, img, service, id, url, author;

  WebtoonDetailKakaoModel.fromJson(Map<dynamic, dynamic> json)
      : title = json['title'],
        img = json['img'],
        id = json['_id'],
        service = json['service'],
        url = json['url'],
        author = json['author'];
}
