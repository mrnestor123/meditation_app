import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/layout.dart';
import 'package:meditation_app/presentation/pages/main_screen.dart';
import 'package:meditation_app/presentation/pages/oldwidgets/button.dart';
import 'package:meditation_app/presentation/pages/welcome/carrousel_intro.dart';
import 'package:provider/provider.dart';

class SetUserData extends StatefulWidget {
  @override
  _SetUserDataState createState() => _SetUserDataState();
}

class _SetUserDataState extends State<SetUserData> {
  final TextEditingController _nameController = new TextEditingController();
  var focusNode = FocusNode();


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
            Text('Type your username', style: Configuration.text('medium', Colors.white)),
            SizedBox(height: Configuration.verticalspacing),
            TextField(
              controller: _nameController, 
              style: Configuration.text('small', Colors.white)
            ),
            SizedBox(height: Configuration.verticalspacing * 2),
            BaseButton(
              text: 'Set',
              textcolor: Colors.black,
              color: Colors.white,
              onPressed:() async{
                    //PPORQUE HAGO GETDATA AQUI????
                    if(_nameController.text !=null &&  _nameController.text.isNotEmpty){
                      if(_userstate.user == null && _loginstate.loggeduser !=null || _userstate.user != null && _loginstate.loggeduser!=null && _loginstate.loggeduser.coduser != _userstate.user.coduser){
                        _userstate.setUser(_loginstate.loggeduser);
                      }
                      _userstate.changeName(_nameController.text);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => CarrouselIntro()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
            ),
          ],
        ),
      ),
    );
  }
}
