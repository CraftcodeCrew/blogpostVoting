import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blogpostvoting/Author.dart';
import 'package:rxdart/subjects.dart';

class Vote {
  final DocumentSnapshot votedAuthor;

  Vote(this.votedAuthor);
}

class AuthorBloc {

  final StreamController<Vote> _authorController =
    StreamController<Vote>();

  final BehaviorSubject<QuerySnapshot> _firebaseStream =
    BehaviorSubject<QuerySnapshot>(seedValue: null);

  final BehaviorSubject<bool> _voted =
    BehaviorSubject<bool>(seedValue: false);

  AuthorBloc() {
    _authorController.stream.listen((data) => commitToFireBase(data));
    _firebaseStream.addStream(Firestore.instance.collection("AuthorVotes").snapshots());
  }


  Sink<Vote> get authorVote => _authorController.sink;
  Stream<QuerySnapshot> get firebaseStream => _firebaseStream.stream;

  void dispose(){
    _authorController.close();
  }

  void commitToFireBase(Vote vote) {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(vote.votedAuthor.reference);
      await transaction.update(freshSnap.reference, {
        'Votes' : freshSnap['Votes'] +1
      });
    });
  }

}