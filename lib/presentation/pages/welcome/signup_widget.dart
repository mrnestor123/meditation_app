/*
*  signup_widget.dart
*  Spacebook
*
*  Created by Supernova.
*  Copyright © 2018 Supernova. All rights reserved.
    */

import 'package:flutter/material.dart';
import 'package:spacebook/login_widget/login_widget.dart';
import 'package:spacebook/values/values.dart';

class SignupWidget extends StatelessWidget {
  void onSwitchValueChanged(BuildContext context) {}

  void onSignUpPressed(BuildContext context) {}

  void onLogInPressed(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => LoginWidget()));

  void onGroupPressed(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => this.onGroupPressed(context),
          icon: Image.asset(
            "assets/images/group-2.png",
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.31089, 1.09827),
            end: Alignment(0.68911, -0.09827),
            stops: [
              0,
              1,
            ],
            colors: [
              Color.fromARGB(255, 248, 132, 98),
              Color.fromARGB(255, 140, 28, 140),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 89),
                child: Text(
                  "Sign up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.accentText,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w700,
                    fontSize: 42,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  "It’s free and always will be.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.accentText,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              height: 193,
              margin: EdgeInsets.only(left: 20, top: 75, right: 20),
              decoration: BoxDecoration(
                color: AppColors.primaryBackground,
                boxShadow: [
                  Shadows.primaryShadow,
                ],
                borderRadius: Radii.k2pxRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 20,
                    margin: EdgeInsets.only(left: 15, top: 14, right: 18),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Your nickname",
                        contentPadding: EdgeInsets.all(0),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      autocorrect: false,
                    ),
                  ),
                  Opacity(
                    opacity: 0.1,
                    child: Container(
                      height: 1,
                      margin: EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryElement,
                      ),
                      child: Container(),
                    ),
                  ),
                  Container(
                    height: 20,
                    margin: EdgeInsets.only(left: 15, top: 14, right: 18),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Your spacemail",
                        contentPadding: EdgeInsets.all(0),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      autocorrect: false,
                    ),
                  ),
                  Opacity(
                    opacity: 0.1,
                    child: Container(
                      height: 1,
                      margin: EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryElement,
                      ),
                      child: Container(),
                    ),
                  ),
                  Container(
                    height: 20,
                    margin: EdgeInsets.only(left: 15, top: 14, right: 18),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Password (40+ characters)",
                        contentPadding: EdgeInsets.all(0),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      obscureText: true,
                      maxLines: 1,
                      autocorrect: false,
                    ),
                  ),
                  Opacity(
                    opacity: 0.1,
                    child: Container(
                      height: 1,
                      margin: EdgeInsets.only(top: 11),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryElement,
                      ),
                      child: Container(),
                    ),
                  ),
                  Container(
                    height: 20,
                    margin: EdgeInsets.only(left: 15, top: 12, right: 18),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Your nickname",
                        contentPadding: EdgeInsets.all(0),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      obscureText: true,
                      maxLines: 1,
                      autocorrect: false,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 32,
              margin: EdgeInsets.only(left: 25, top: 20, right: 25),
              child: Row(
                children: [
                  Text(
                    "I agree with terms and conditions",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColors.accentText,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 51,
                    height: 32,
                    child: Switch.adaptive(
                      value: true,
                      inactiveTrackColor: Color.fromARGB(60, 0, 0, 0),
                      onChanged: (value) {},
                      activeColor: Color.fromARGB(255, 142, 28, 138),
                      activeTrackColor: Color.fromARGB(255, 142, 28, 138),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              height: 60,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: FlatButton(
                onPressed: () => this.onSignUpPressed(context),
                color: Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
                textColor: Color.fromARGB(255, 217, 104, 111),
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/icon-sign-up.png",
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "SIGN UP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 217, 104, 111),
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 232,
                height: 18,
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 27),
                      child: Text(
                        "Already registered? ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.accentText,
                          fontFamily: "Lato",
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 47,
                      height: 18,
                      child: FlatButton(
                        onPressed: () => this.onLogInPressed(context),
                        color: Color.fromARGB(0, 0, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                        textColor: Color.fromARGB(255, 255, 255, 255),
                        padding: EdgeInsets.all(0),
                        child: Text(
                          "Log In!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontFamily: "Lato",
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
