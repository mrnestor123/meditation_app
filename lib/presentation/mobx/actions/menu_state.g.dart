// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MenuState on _MenuState, Store {
  final _$sidebarRouteAtom = Atom(name: '_MenuState.sidebarRoute');

  @override
  String get sidebarRoute {
    _$sidebarRouteAtom.context.enforceReadPolicy(_$sidebarRouteAtom);
    _$sidebarRouteAtom.reportObserved();
    return super.sidebarRoute;
  }

  @override
  set sidebarRoute(String value) {
    _$sidebarRouteAtom.context.conditionallyRunInAction(() {
      super.sidebarRoute = value;
      _$sidebarRouteAtom.reportChanged();
    }, _$sidebarRouteAtom, name: '${_$sidebarRouteAtom.name}_set');
  }

  final _$bottomenuindexAtom = Atom(name: '_MenuState.bottomenuindex');

  @override
  int get bottomenuindex {
    _$bottomenuindexAtom.context.enforceReadPolicy(_$bottomenuindexAtom);
    _$bottomenuindexAtom.reportObserved();
    return super.bottomenuindex;
  }

  @override
  set bottomenuindex(int value) {
    _$bottomenuindexAtom.context.conditionallyRunInAction(() {
      super.bottomenuindex = value;
      _$bottomenuindexAtom.reportChanged();
    }, _$bottomenuindexAtom, name: '${_$bottomenuindexAtom.name}_set');
  }

  final _$_MenuStateActionController = ActionController(name: '_MenuState');

  @override
  Future<dynamic> switchbottommenu({int index}) {
    final _$actionInfo = _$_MenuStateActionController.startAction();
    try {
      return super.switchbottommenu(index: index);
    } finally {
      _$_MenuStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> switchsidebarmenu({String route}) {
    final _$actionInfo = _$_MenuStateActionController.startAction();
    try {
      return super.switchsidebarmenu(route: route);
    } finally {
      _$_MenuStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'sidebarRoute: ${sidebarRoute.toString()},bottomenuindex: ${bottomenuindex.toString()}';
    return '{$string}';
  }
}
