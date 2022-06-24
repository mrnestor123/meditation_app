// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfileState on _ProfileState, Store {
  final _$selectedAtom = Atom(name: '_ProfileState.selected');

  @override
  User get selected {
    _$selectedAtom.reportRead();
    return super.selected;
  }

  @override
  set selected(User value) {
    _$selectedAtom.reportWrite(value, super.selected, () {
      super.selected = value;
    });
  }

  final _$loadingAtom = Atom(name: '_ProfileState.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$initAsyncAction = AsyncAction('_ProfileState.init');

  @override
  Future<dynamic> init(User u, User me) {
    return _$initAsyncAction.run(() => super.init(u, me));
  }

  @override
  String toString() {
    return '''
selected: ${selected},
loading: ${loading}
    ''';
  }
}
