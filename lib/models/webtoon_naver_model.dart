class WebtoonNaverModel {
  final String id, title, thumb;

  WebtoonNaverModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
}
