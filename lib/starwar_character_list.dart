import 'package:d4/starwar_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_debounce.dart';

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
  // late bool _hasMore;
  // late bool _loading;
  // final int _defaultCharatorPerPageCount = 10;
  // final int _nextPageThreshold = 10;
  final ScrollController _scrollController;

  _StarWarCharacterList()
      : _repo = new StarWarRepo(),
        _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _page = 1;
    _people = [];
    // _hasMore = true;
    // _loading = true;
    fetchPeople();
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Future<void> fetchPeople() async {
    var people = await _repo.fetchPeople(page: _page);
    setState(() {
      _people = List<People>.from(people);
    });
  }

  // String getIdCharacter(url) {
  //   final id = url.split("https://swapi.dev/api/people/")[1];
  //   return id.split('/')[0];
  // }

  Widget getBody() {
    _scrollController.addListener(() {});
    return ListView.builder(
        controller: _scrollController,
        itemCount: _people.length,
        itemBuilder: (context, index) {
          if (index == _people.length) {
            fetchPeople();
          }
          if (index == _people.length) {}
          final People people = _people[index];
          final int id = _people.length;
          return Card(
            child: Column(
              children: <Widget>[
                Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(
                        "https://starwars-visualguide.com/assets/img/characters/${id}.jpg"),
                    fit: BoxFit.fitWidth,
                  )),
                ),
                Text(
                  people.name,
                ),
              ],
            ),
          );
        });
  }
}
