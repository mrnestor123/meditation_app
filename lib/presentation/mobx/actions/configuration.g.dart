// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ConfigurationState on _ConfigurationState, Store {
  final _$nightmodeAtom = Atom(name: '_ConfigurationState.nightmode');

  @override
  bool get nightmode {
    _$nightmodeAtom.context.enforceReadPolicy(_$nightmodeAtom);
    _$nightmodeAtom.reportObserved();
    return super.nightmode;
  }

  @override
  set nightmode(bool value) {
    _$nightmodeAtom.context.conditionallyRunInAction(() {
      super.nightmode = value;
      _$nightmodeAtom.reportChanged();
    }, _$nightmodeAtom, name: '${_$nightmodeAtom.name}_set');
  }

  final _$maincolorAtom = Atom(name: '_ConfigurationState.maincolor');

  @override
  Color get maincolor {
    _$maincolorAtom.context.enforceReadPolicy(_$maincolorAtom);
    _$maincolorAtom.reportObserved();
    return super.maincolor;
  }

  @override
  set maincolor(Color value) {
    _$maincolorAtom.context.conditionallyRunInAction(() {
      super.maincolor = value;
      _$maincolorAtom.reportChanged();
    }, _$maincolorAtom, name: '${_$maincolorAtom.name}_set');
  }

  final _$greyAtom = Atom(name: '_ConfigurationState.grey');

  @override
  Color get grey {
    _$greyAtom.context.enforceReadPolicy(_$greyAtom);
    _$greyAtom.reportObserved();
    return super.grey;
  }

  @override
  set grey(Color value) {
    _$greyAtom.context.conditionallyRunInAction(() {
      super.grey = value;
      _$greyAtom.reportChanged();
    }, _$greyAtom, name: '${_$greyAtom.name}_set');
  }

  final _$whitecolorAtom = Atom(name: '_ConfigurationState.whitecolor');

  @override
  Color get whitecolor {
    _$whitecolorAtom.context.enforceReadPolicy(_$whitecolorAtom);
    _$whitecolorAtom.reportObserved();
    return super.whitecolor;
  }

  @override
  set whitecolor(Color value) {
    _$whitecolorAtom.context.conditionallyRunInAction(() {
      super.whitecolor = value;
      _$whitecolorAtom.reportChanged();
    }, _$whitecolorAtom, name: '${_$whitecolorAtom.name}_set');
  }

  final _$_ConfigurationStateActionController =
      ActionController(name: '_ConfigurationState');

  @override
  void switchnightmode() {
    final _$actionInfo = _$_ConfigurationStateActionController.startAction();
    try {
      return super.switchnightmode();
    } finally {
      _$_ConfigurationStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'nightmode: ${nightmode.toString()},maincolor: ${maincolor.toString()},grey: ${grey.toString()},whitecolor: ${whitecolor.toString()}';
    return '{$string}';
  }
}
