import 'dart:collection';

import 'package:blogpostvoting/Author.dart';

final CrackeHoe crackeHoe = CrackeHoe._sample();

class CrackeHoe {

  static const List<Author> _sampleAuthors = const <Author>[
    const Author("Danny"),
    const Author("Sören"),
    const Author("Dominik"),
    const Author("Leon"),
    const Author("Cem")
  ];

  final List<Author> _authors;

  CrackeHoe._sample() : _authors = _sampleAuthors;

  UnmodifiableListView<Author> get authors =>
      UnmodifiableListView<Author>(_authors);
}