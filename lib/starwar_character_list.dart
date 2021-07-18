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
  // final int _defaultCharaterPerPageCount = 10;
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
    _scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    // print(_controller.offset);
    // print('>> ${_controller.position.maxScrollExtent}');
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (_repo.next != null) {
        setState(() {
          _page += 1;
          _loading = true;
        });
        fetchPeople();
        print("page $_page, next ${_repo.next}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Future<void> fetchPeople() async {
    try {
      var people = await _repo.fetchPeople(page: _page);
      setState(() {
        // _hasMore = people.length == _defaultCharaterPerPageCount;
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
          itemCount: _people.length + (_repo.next != null ? 1 : 0),
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
            final picId =
                people.url.toString().split("https://swapi.dev/api/people/")[1];
            print(picId);
            return Card(
              child: Column(
                children: <Widget>[
                  Image.network(
                    "https://starwars-visualguide.com/assets/img/characters/${picId.split("/")[0]}.jpg",
                    // fit: BoxFit.fitWidth,
                    width: 500,
                    height: 500,
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
