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
        title: 'Bloc',
          home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authorBloc = AuthorProvider.of(context);
    authorBloc.contextSink.add(context);
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
              imageUrl: document['Image'],
              onTab: (){
                authorBloc.authorVote.add(Vote(document));
                authorBloc.wigetSink.add(new SecoundScreen());
              },
            );
  }
}


class SecoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authorBloc = AuthorProvider.of(context);
    authorBloc.contextSink.add(context);
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
    floatingActionButton: new FloatingActionButton(
      tooltip: 'clear',
      child: new Icon(Icons.clear),
      onPressed: () {
        authorBloc.fabSink.add(true);
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

