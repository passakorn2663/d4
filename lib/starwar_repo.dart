import 'package:dio/dio.dart';

class People {
  final String name;
  String url;

  People({required this.name, required this.url /*, required this.id*/});

  factory People.fromJson(Map<String, dynamic> data) {
    // var picId = data['url'].split("http://swapi.dev/api/people/")[1];
    return People(
        name: data['name'], url: data['url'] /*, id: picId.split('/')[0]*/);
  }

  get length => null;
}

class StarWarRepo {
  late String? next;
  Future<List<People>> fetchPeople({int page = 1}) async {
    var response = await Dio().get('https://swapi.dev/api/people/?page=$page');
    List<dynamic> results = response.data['results'];
    next = response.data['next'];
    return results.map((p) => People.fromJson(p)).toList();
  }
}
