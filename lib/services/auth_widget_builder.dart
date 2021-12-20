import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:flutter_starter/services/auth_service.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:provider/provider.dart';

//https://www.youtube.com/watch?v=B0QX2woHxaU from this tutorial
class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key key, @required this.builder}) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return StreamBuilder<User>(
      stream: authService.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        final User user = snapshot.data;
        if (user != null) {
          /*
          * For any other Provider services that rely on user data can be
          * added to the following MultiProvider list.
          * Once a user has been detected, a re-build will be initiated.
           */
          return MultiProvider(providers: [
            Provider<User>.value(value: user),
            StreamProvider<UserModel>.value(
                initialData: UserModel(),
                value: AuthService().streamFirestoreUser(user))
          ], child: builder(context, snapshot));
        }
        return builder(context, snapshot);
      },
    );
  }
}
