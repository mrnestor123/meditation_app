import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/meditation_screens.dart';
import 'package:meditation_app/presentation/pages/layout.dart';
import 'package:meditation_app/presentation/pages/welcome/carrousel_intro.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/database_entity.dart';

class SetUserData extends StatefulWidget {
  @override
  _SetUserDataState createState() => _SetUserDataState();
}

// COMPROBAR SI EL NOMBRE DE USUARIO YA EXISTE!!
class _SetUserDataState extends State<SetUserData> {
  final TextEditingController _nameController = new TextEditingController();
  var focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool settingUserName = false;
  DateTime currentBackPressTime;

  @override 
  void didChangeDependencies(){
     if(Configuration.width == null){
      Configuration c = new Configuration();
      c.init(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    final _loginstate = Provider.of<LoginState>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light
        ),
      ),
      body: WillPopScope(
        onWillPop:  (){ return checkPop(context); },
        child: containerGradient(
          child: Container(
            height: Configuration.height,
            width: Configuration.width,
            padding: EdgeInsets.all(Configuration.medpadding),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Type your username', style: Configuration.text('medium', Colors.white)),
                  SizedBox(height: Configuration.verticalspacing),
                  TextFormField(
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please, enter a valid username';
                      }else if(value.length < 3){
                        return 'Please, enter a username longer than three characters';
                      }else if(value.length > 15){
                        return 'Username should be longer than fifteen characters';
                      } 
                      return null;
                    },
                    decoration: InputDecoration(
                      errorMaxLines: 2,
                      errorStyle: Configuration.text('small', Colors.redAccent),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                      ),
                    ),
                    controller: _nameController, 
                    style: Configuration.text('smallmedium', Colors.white, font: 'Helvetica')
                  ),
                  SizedBox(height: Configuration.verticalspacing * 2),
                  BaseButton(
                    text: 'Set',
                    textcolor: Colors.white,
                    child: settingUserName ? CircularProgressIndicator() : null,
                    color: Colors.white,
                    onPressed:() async {
                      if(_formKey.currentState.validate()){
                        if(_userstate.user == null && _loginstate.loggeduser !=null || _userstate.user != null && _loginstate.loggeduser!=null && _loginstate.loggeduser.coduser != _userstate.user.coduser){
                          _userstate.setUser(_loginstate.loggeduser);
                        }
                        
                        setState(()=>settingUserName = true);
                        bool success = await _userstate.changeName(_nameController.text);
        
                        setState(()=> settingUserName = false);
                        
                        if(success){
                           Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Layout()),
                            (Route<dynamic> route) => false,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
