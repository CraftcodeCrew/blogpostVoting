import 'package:blogpostvoting/Author.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class AuthorSquare extends StatelessWidget {
  final String author;

 final GestureTapCallback onTab;

  AuthorSquare({
    Key key,
    @required this.author,
    this.onTab
}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new InkWell(
        onTap: onTab,
        child: new Center(
            child: new Text(
              author
            )),
      ),

    );
  }
}