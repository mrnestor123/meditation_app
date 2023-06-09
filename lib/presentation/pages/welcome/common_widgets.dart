

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../mobx/login_register/login_state.dart';
import '../commonWidget/circular_progress.dart';
import '../config/configuration.dart';

class AppleButton extends StatelessWidget {
   const AppleButton({
    this.register,
    Key key,
    @required LoginState state,
  }) : state = state, super(key: key);

  final bool register;
  final LoginState state;
  final bool appleAvailable = false;
  
  void isAvailable(){
    SignInWithApple.isAvailable().then((value) => print('isAVailable $value'));
  
  }

  @override
  Widget build(BuildContext context) {

    isAvailable();
      // copy googlebutton with apple icon
    return Container(
      width:Configuration.width*0.9,
      child: AspectRatio(
        aspectRatio: Configuration.buttonRatio,
        child: ElevatedButton(
          onPressed: () async{
             if(!state.startedlogin){
              await  state.startlogin(
                context,
                type: 'apple',
                register:register
              );
            }
          },
          style: OutlinedButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius)),
            padding: EdgeInsets.symmetric(horizontal:Configuration.bigpadding),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child:  Text((register ? 'Sign up' :'Log in') + ' with apple', style: Configuration.text('subtitle', Colors.white ))),
              Icon(FontAwesomeIcons.apple,color: Colors.white,size: Configuration.smicon)
            ]),
          ),
      ),

    );

  }
}


class GoogleButton extends StatelessWidget {
  const GoogleButton({
    this.register,
    Key key,
    @required LoginState registerstate,
  }) : _registerstate = registerstate, super(key: key);

  final bool register;
  final LoginState _registerstate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width:Configuration.width*0.9,
      child: AspectRatio(
        aspectRatio: Configuration.buttonRatio,
        child: ElevatedButton(
          onPressed: () async{
            if(!_registerstate.startedlogin){
              await _registerstate.startlogin(context, type: 'google', register:register);
            }
          },
          style: OutlinedButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius)),
            padding: EdgeInsets.symmetric(horizontal:Configuration.bigpadding),
          ),
          child: Observer(builder: (context){
            if(_registerstate.startedgooglelogin){
              return CircularProgress(color:Colors.white);
            } 
            else{
              return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Text((register ? 'Sign up' :'Log in') + ' with google', style: Configuration.text('subtitle', Colors.white ))),
                Icon(FontAwesomeIcons.google,color: Colors.white,size: Configuration.smicon)
              ]);
            }
          })
          ),
      ),
   );
  }
}
