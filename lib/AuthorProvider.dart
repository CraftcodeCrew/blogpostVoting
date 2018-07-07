import 'package:blogpostvoting/AuthorBloc.dart';
import 'package:flutter/widgets.dart';

class AuthorProvider extends InheritedWidget {
  final AuthorBloc authorBloc;


  AuthorProvider({
    Key key,
    AuthorBloc authorBloc,
    Widget child,
  })
      : authorBloc = authorBloc ?? AuthorBloc(),
        super(key: key, child: child);


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;


  static AuthorBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(AuthorProvider) as AuthorProvider)
          .authorBloc;

}
