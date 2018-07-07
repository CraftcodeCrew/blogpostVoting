import 'package:blogpostvoting/AuthorBloc.dart';
import 'package:blogpostvoting/AuthorProvider.dart';
import 'package:blogpostvoting/author_square.dart';
import 'package:blogpostvoting/cracke_hoe.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthorProvider(
      child: MaterialApp(
        title: 'Bloc',
          home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authorbloc = AuthorProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Bloc"),
      ),
      body: AuthorGrid(),
    );
  }
}


class AuthorGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authorBloc = AuthorProvider.of(context);
    return GridView.count(crossAxisCount: 2,
    children: crackeHoe.authors.map((author) {
      return AuthorSquare(
        author: author,
        onTab: (){
          authorBloc.authorVote.add(Vote(author));
        },
      );
    }).toList(),
    );
  }

}
