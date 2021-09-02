import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/oldwidgets/button.dart';
import 'package:provider/provider.dart';

class SetUserData extends StatefulWidget {
  @override
  _SetUserDataState createState() => _SetUserDataState();
}

class _SetUserDataState extends State<SetUserData> {
  final TextEditingController _nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    final _loginstate = Provider.of<LoginState>(context);

    return Scaffold(
      body: Container(
        height: Configuration.height,
        width: Configuration.width,
        color: Configuration.maincolor,
        padding: EdgeInsets.all(Configuration.medpadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select your username', style: Configuration.text('small', Colors.white)),
            SizedBox(height: Configuration.height * 0.03),
            TextField(controller: _nameController),
            SizedBox(height: Configuration.height * 0.03),
            AspectRatio(
              aspectRatio: 8/1,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    padding: EdgeInsets.all(12.0)
                  ),
                  onPressed: () async{
                    await _userstate.getData();
                    if(_userstate.user == null || _loginstate.loggeduser.coduser != _userstate.user.coduser){
                      _userstate.setUser(_loginstate.loggeduser);
                    }
                    _userstate.changeName(_nameController.text);
                    Navigator.pushReplacementNamed(context, '/main');
                  },
                  child: Text(
                    'Set',
                    style: Configuration.text('medium', Colors.black),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
