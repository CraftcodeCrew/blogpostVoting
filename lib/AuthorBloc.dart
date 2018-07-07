import 'dart:async';

import 'package:blogpostvoting/Author.dart';
import 'package:rxdart/subjects.dart';

class Vote {
  final Author votedAuthor;

  Vote(this.votedAuthor);
}

class AuthorBloc {

  final StreamController<Vote> _authorController =
    StreamController<Vote>();

  final BehaviorSubject<bool> _voted =
    BehaviorSubject<bool>(seedValue: false);

  AuthorBloc() {}


  Sink<Vote> get authorVote => _authorController.sink;

  void dispose(){
    _authorController.close();
  }

}