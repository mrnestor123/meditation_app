import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';

part 'configuration.g.dart';

class ConfigurationState extends _ConfigurationState with _$ConfigurationState {
  ConfigurationState() : super();
}

abstract class _ConfigurationState with Store {
  _ConfigurationState() {
    maincolor = Color.fromRGBO(135, 61, 175, 100);
    grey = Colors.grey;
    whitecolor = Colors.white;
  }

  @observable
  bool nightmode = false;

  @observable
  Color maincolor;
  @observable
  Color grey;
  @observable
  Color whitecolor;

  @action
  void switchnightmode() {
    nightmode = !nightmode;
    maincolor = !nightmode ? Color.fromRGBO(135, 61, 175, 100) : Colors.black;
    grey = !nightmode ? Colors.grey : Colors.blueGrey;
    whitecolor = !nightmode ? Colors.white : Colors.black;
  }
}
