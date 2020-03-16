/*
*  login_widget.dart
*  Spacebook
*
*  Created by Supernova.
*  Copyright © 2018 Supernova. All rights reserved.
    */

import 'package:flutter/material.dart';

class LoginWidget extends StatelessWidget {
  void onLoginPressed(BuildContext context) {}

  void onForgotYourPasswordPressed(BuildContext context) {}

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
                margin: EdgeInsets.only(top: 114),
                child: Text(
                  "Log in",
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
                  "Welcome back.",
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
              height: 101,
              margin: EdgeInsets.only(left: 20, top: 92, right: 20),
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
                    margin: EdgeInsets.only(left: 15, top: 14, right: 15),
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
                    margin: EdgeInsets.only(left: 15, top: 14, right: 15),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Your password",
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
            Spacer(),
            Container(
              height: 60,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 11),
              child: FlatButton(
                onPressed: () => this.onLoginPressed(context),
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
                      "assets/images/icon-log-in.png",
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "LOG IN",
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
                width: 150,
                height: 18,
                margin: EdgeInsets.only(bottom: 19),
                child: FlatButton(
                  onPressed: () => this.onForgotYourPasswordPressed(context),
                  color: Color.fromARGB(0, 0, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  textColor: Color.fromARGB(255, 255, 255, 255),
                  padding: EdgeInsets.all(0),
                  child: Text(
                    "Forgot your password?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontFamily: "Lato",
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
