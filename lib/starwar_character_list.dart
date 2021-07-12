import 'package:d4/starwar_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarWarCharacterList extends StatefulWidget {
  StarWarCharacterList({Key? key}) : super(key: key);

  @override
  _StarWarCharacterList createState() {
    return _StarWarCharacterList();
  }
}

class _StarWarCharacterList extends State {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(
                  "https://https://starwars-visualguide.com/assets/img/characters/1.jpg"),
              fit: BoxFit.fitWidth,
            )),
            child: Text('Luke'),
          ),
        )
      ],
    );
  }
}
