// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MenuState on _MenuState, Store {
  final _$sidebarRouteAtom = Atom(name: '_MenuState.sidebarRoute');

  @override
  String get sidebarRoute {
    _$sidebarRouteAtom.reportRead();
    return super.sidebarRoute;
  }

  @override
  set sidebarRoute(String value) {
    _$sidebarRouteAtom.reportWrite(value, super.sidebarRoute, () {
      super.sidebarRoute = value;
    });
  }

  final _$bottomenuindexAtom = Atom(name: '_MenuState.bottomenuindex');

  @override
  int get bottomenuindex {
    _$bottomenuindexAtom.reportRead();
    return super.bottomenuindex;
  }

  @override
  set bottomenuindex(int value) {
    _$bottomenuindexAtom.reportWrite(value, super.bottomenuindex, () {
      super.bottomenuindex = value;
    });
  }

  final _$_MenuStateActionController = ActionController(name: '_MenuState');

  @override
  Future<dynamic> switchbottommenu({int index}) {
    final _$actionInfo = _$_MenuStateActionController.startAction(
        name: '_MenuState.switchbottommenu');
    try {
      return super.switchbottommenu(index: index);
    } finally {
      _$_MenuStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> switchsidebarmenu({String route}) {
    final _$actionInfo = _$_MenuStateActionController.startAction(
        name: '_MenuState.switchsidebarmenu');
    try {
      return super.switchsidebarmenu(route: route);
    } finally {
      _$_MenuStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
sidebarRoute: ${sidebarRoute},
bottomenuindex: ${bottomenuindex}
    ''';
  }
}
