import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
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
    return Scaffold(
      body: Container(
        height: Configuration.height,
        width: Configuration.width,
        color: Configuration.maincolor,
        padding: EdgeInsets.all(Configuration.medpadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select your username',
                style: Configuration.text('medium', Colors.white)),
            SizedBox(height: Configuration.height * 0.03),
            TextField(controller: _nameController),
            SizedBox(height: Configuration.height * 0.03),
            RaisedButton(
                onPressed: () {
                  _userstate.changeName(_nameController.text);
                  Navigator.pushReplacementNamed(context, '/main');
                },
                child: Padding(
                  padding: EdgeInsets.all(Configuration.tinpadding),
                  child: Text(
                    'Set',
                    style: Configuration.text('big', Colors.black),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
