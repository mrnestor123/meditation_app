import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final List<ReactionDisposer> _disposers = [];
  UserState _user;


  @override
  void initState() {
    super.initState();
  }

  void userisLogged(context) async {
   // await new Future.delayed(Duration(seconds: 30));
    await _user.getData();
    await _user.userisLogged();
    _user.loggedin
        ? Navigator.pushNamed(context, '/main')
        : Navigator.pushNamed(context, '/welcome');

    /*reaction(
        (_) => _user.loggedin,
        (loggedin) => loggedin
            ? Navigator.pushNamed(context, '/main')
            : Navigator.pushNamed(context, '/welcome'));*/
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<UserState>(context);
    //comprobamos si el usuario esta loggeado
    userisLogged(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('images/logo.jpg', fit: BoxFit.cover),
        ],
      ),
    );
  }
}
