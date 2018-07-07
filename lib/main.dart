import 'package:blogpostvoting/AuthorBloc.dart';
import 'package:blogpostvoting/AuthorProvider.dart';
import 'package:blogpostvoting/author_square.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthorProvider(
      child: MaterialApp(
        routes: <String, WidgetBuilder> {
          '/vote' : (BuildContext context) => MyHomePage(),
          '/result' : (BuildContext context) => SecoundScreen()
        },
        title: 'Bloc',
          home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    return new StreamBuilder(
      stream: authorBloc.firebaseStream,
      builder: (context, snapshot) {
        if (snapshot != null && !snapshot.hasData) return const Text('Loading...');
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) => 
            _buildGridItem(context, snapshot.data.documents[index], authorBloc), 
        );
      },
    );
  }

  Widget _buildGridItem(BuildContext context, DocumentSnapshot document, AuthorBloc authorBloc) {
            return new AuthorSquare(
              author: document['Author'],
              onTab: (){
                authorBloc.authorVote.add(Vote(document));
                Navigator.of(context).pushNamed('/result');
              },
            );
  }
}


class SecoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authorBloc = AuthorProvider.of(context);
    return new Scaffold(
      appBar: new AppBar(
      title: new Text("Result"),
    ),
    body: new StreamBuilder(
      stream: authorBloc.firebaseStream,
      builder: (context, snapshot) {
        if (snapshot != null && !snapshot.hasData) return const Text('Loading...');
        return new ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) => 
            _buildItem(context, snapshot.data.documents[index]), 
        );
      },
    ),
    );
  }

   Widget _buildItem(BuildContext context, DocumentSnapshot document) {
            return new ListTile(
              onTap: null,
              leading: new Text(document['Votes'].toString()),
              title: new Text(document['Author']),
            );
  }
}

