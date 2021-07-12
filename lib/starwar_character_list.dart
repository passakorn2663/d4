import 'package:d4/starwar_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarWarCharacterList extends StatefulWidget {
  StarWarCharacterList({Key? key}) : super(key: key);

  @override
  _StarWarCharacterList createState() {
    return _StarWarCharacterList();
  }
}

class _StarWarCharacterList extends State<StarWarCharacterList> {
  final StarWarRepo _repo;
  late int _page;
  late List<People> _people;
  late bool _hasMore;
  late bool _loading;
  final int _defaultCharatorPerPageCount = 10;
  final int _nextPageThreshold = 10;

  _StarWarCharacterList() : _repo = new StarWarRepo();

  @override
  void initState() {
    super.initState();
    _page = 1;
    _people = [];
    _hasMore = true;
    _loading = true;
    fetchPeople();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Starwarlist"),
        ),
        body: getBody());
  }

  Future<void> fetchPeople() async {
    var people = await _repo.fetchPeople(page: _page);
    setState(() {
      _people = List<People>.from(_people);
    });
  }

  // String getIdCharacter(url) {
  //   final id = url.split("https://swapi.dev/api/people/")[1];
  //   return id.split('/')[0];
  // }

  Widget getBody() {
    return ListView.builder(
        itemCount: _people.length,
        itemBuilder: (context, index) {
          if (index == _people.length) {
            fetchPeople();
          }
          if (index == _people.length) {}
          final People people = _people[index];
          return Card(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    "https://starwars-visualguide.com/assets/img/characters/${1}.jpg"),
                fit: BoxFit.fitWidth,
              )),
              child: Text(
                people.name,
              ),
            ),
          );
        });
  }
}
