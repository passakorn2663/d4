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
  late bool _loading;
  // final int _defaultCharatorPerPageCount = 10;
  // final int _nextPageThreshold = 10;
  late bool _error;
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
    _loading = true;
    _error = false;
    fetchPeople();
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Future<void> fetchPeople() async {
    try {
      var people = await _repo.fetchPeople(page: _page);
      setState(() {
        _loading = false;
        _people = List<People>.from(people);
        _page += 1;
      });
    } catch (e) {
      _loading = false;
      _error = true;
    }
  }

  // String getIdCharacter(url) {
  //   final id = url.split("https://swapi.dev/api/people/")[1];
  //   return id.split('/')[0];
  // }

  Widget getBody() {
    _scrollController.addListener(() {});
    if (_people.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(
            child: InkWell(
          onTap: () {
            setState(() {
              _loading = true;
              _error = false;
              fetchPeople();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Error while loading photos, tap to try agin"),
          ),
        ));
      }
    } else {
      return ListView.builder(
          controller: _scrollController,
          itemCount: _people.length,
          itemBuilder: (context, index) {
            if (index == _people.length) {
              if (_error) {
                return Center(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _loading = true;
                      _error = false;
                      fetchPeople();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text("Error while loading data, tap to try agin"),
                  ),
                ));
              } else {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ));
              }
            }
            final People people = _people[index];
            final int id = _people.length;
            return Card(
              child: Column(
                children: <Widget>[
                  Image.network(
                    "https://starwars-visualguide.com/assets/img/characters/${id}.jpg",
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                    height: 160,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(people.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
            );
          });
    }
    return Container();
  }
}
