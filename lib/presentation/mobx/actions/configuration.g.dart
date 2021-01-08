// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ConfigurationState on _ConfigurationState, Store {
  final _$nightmodeAtom = Atom(name: '_ConfigurationState.nightmode');

  @override
  bool get nightmode {
    _$nightmodeAtom.reportRead();
    return super.nightmode;
  }

  @override
  set nightmode(bool value) {
    _$nightmodeAtom.reportWrite(value, super.nightmode, () {
      super.nightmode = value;
    });
  }

  final _$maincolorAtom = Atom(name: '_ConfigurationState.maincolor');

  @override
  Color get maincolor {
    _$maincolorAtom.reportRead();
    return super.maincolor;
  }

  @override
  set maincolor(Color value) {
    _$maincolorAtom.reportWrite(value, super.maincolor, () {
      super.maincolor = value;
    });
  }

  final _$greyAtom = Atom(name: '_ConfigurationState.grey');

  @override
  Color get grey {
    _$greyAtom.reportRead();
    return super.grey;
  }

  @override
  set grey(Color value) {
    _$greyAtom.reportWrite(value, super.grey, () {
      super.grey = value;
    });
  }

  final _$whitecolorAtom = Atom(name: '_ConfigurationState.whitecolor');

  @override
  Color get whitecolor {
    _$whitecolorAtom.reportRead();
    return super.whitecolor;
  }

  @override
  set whitecolor(Color value) {
    _$whitecolorAtom.reportWrite(value, super.whitecolor, () {
      super.whitecolor = value;
    });
  }

  final _$_ConfigurationStateActionController =
      ActionController(name: '_ConfigurationState');

  @override
  void switchnightmode() {
    final _$actionInfo = _$_ConfigurationStateActionController.startAction(
        name: '_ConfigurationState.switchnightmode');
    try {
      return super.switchnightmode();
    } finally {
      _$_ConfigurationStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
nightmode: ${nightmode},
maincolor: ${maincolor},
grey: ${grey},
whitecolor: ${whitecolor}
    ''';
  }
}
