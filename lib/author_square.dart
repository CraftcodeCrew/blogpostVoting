import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';

class AuthorSquare extends StatelessWidget {
  final String author;
  final String imageUrl;

 final GestureTapCallback onTab;

  AuthorSquare({
    Key key,
    @required this.author,
    @required this.imageUrl,
    this.onTab
}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: new CircleAvatar(
        child: Image.network(imageUrl)
      ),
      title: new Text(author),
      onTap: onTab,
    );
  }
}