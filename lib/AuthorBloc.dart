import 'dart:async';
import 'package:async/async.dart';
import 'package:blogpostvoting/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class Vote {
  final DocumentSnapshot votedAuthor;
  Vote(this.votedAuthor);
}

class AuthorBloc {

  final StreamController<Vote> _authorController =
    StreamController<Vote>();

  final StreamController<Widget> _widgetController =
    StreamController<Widget>();

  final StreamController<bool> _fabController =
    StreamController<bool>();

  final BehaviorSubject<QuerySnapshot> _firebaseStream =
    BehaviorSubject<QuerySnapshot>(seedValue: null);



  final BehaviorSubject<bool> _voted =
    BehaviorSubject<bool>(seedValue: false);

  final BehaviorSubject<BuildContext> _contextStream = 
    BehaviorSubject<BuildContext>(seedValue: null);

  AuthorBloc() {
    this._readVotedPreference();
    _authorController.stream.listen((data) => commitToFireBase(data));
    _firebaseStream.addStream(Firestore.instance.collection("AuthorVotes").snapshots());
    _firebaseStream.listen((data) => _checkForEmptyVotes(data));
    Observable.zip2(_widgetController.stream, _contextStream.stream, 
        (a,b) => new Tuple2<Widget, BuildContext>(a,b)).listen((data) => _navigateToResults(data));

    Observable.zip2(_firebaseStream.stream, _fabController.stream, 
        (a,b) => a).listen((data) => _initRevote(data));
      }
        
        Sink<Vote> get authorVote => _authorController.sink;
          Stream<QuerySnapshot> get firebaseStream => _firebaseStream.stream;
          Sink<BuildContext> get contextSink => _contextStream.sink;
          Sink<Widget> get wigetSink => _widgetController.sink;
          Sink<bool> get fabSink => _fabController.sink;
        
          void dispose(){
            _authorController.close();
          }
        
          void _readVotedPreference() async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            bool voted = prefs.getBool('voted') ?? false;
            if(voted) wigetSink.add(new SecoundScreen());
          }
    
          Future<bool> _writeVotedPreference(bool voted) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            return await prefs.setBool('voted', voted);
          }
        
          void _navigateToResults(Tuple2<Widget, BuildContext> tuple) {
               Navigator.pushReplacement(
                          tuple.item2,
                          new MaterialPageRoute(
                            builder : (BuildContext context) => tuple.item1));
          }
        
          void commitToFireBase(Vote vote) {
            Firestore.instance.runTransaction((transaction) async {
              if(await (_writeVotedPreference(true))) {
                DocumentSnapshot freshSnap = await transaction.get(vote.votedAuthor.reference);
                await transaction.update(freshSnap.reference, {
                  'Votes' : freshSnap['Votes'] +1
                });
              }
            });
          }
        
         void _checkForEmptyVotes(QuerySnapshot data) async {
            int votes = data.documents
              .map((snap) => snap.data['Votes'])
              .fold(0, (a,b) => a+b);
    
            if(votes <= 0) {
              wigetSink.add(new MyHomePage());
              await _writeVotedPreference(false);
            }
          }
    
    void _initRevote(QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) async => await _setDatapointToNull(doc));
    }

      Future<void> _setDatapointToNull(DocumentSnapshot datapoint) async {
            Firestore.instance.runTransaction((transaction) async {
                DocumentSnapshot freshSnap = await transaction.get(datapoint.reference);
                return await transaction.update(freshSnap.reference, {
                  'Votes' : 0
                });
            });
      }

}