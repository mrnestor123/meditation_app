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
  UserState _login;

  @override
  void dispose() {
    _disposers.forEach((disposer) => disposer());
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _login = Provider.of<UserState>(context);
    _disposers.add(
      reaction((_) => _login.loggedin, (_) {
        _login.loggedin
            ? Navigator.pushNamed(context, '/main')
            : Navigator.pushNamed(context, '/welcome');
      }),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void userisLogged(context) async {
  //  await new Future.delayed(Duration(seconds: 30));
    _login.userisLogged();
    /*reaction(
        (_) => _login.loggedin,
        (loggedin) => loggedin
            ? Navigator.pushNamed(context, '/main')
            : Navigator.pushNamed(context, '/welcome'));*/
  }

  @override
  Widget build(BuildContext context) {
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
