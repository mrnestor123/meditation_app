// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RequestState on _RequestState, Store {
  final _$requestsAtom = Atom(name: '_RequestState.requests');

  @override
  List<Request> get requests {
    _$requestsAtom.reportRead();
    return super.requests;
  }

  @override
  set requests(List<Request> value) {
    _$requestsAtom.reportWrite(value, super.requests, () {
      super.requests = value;
    });
  }

  final _$selectedrequestAtom = Atom(name: '_RequestState.selectedrequest');

  @override
  Request get selectedrequest {
    _$selectedrequestAtom.reportRead();
    return super.selectedrequest;
  }

  @override
  set selectedrequest(Request value) {
    _$selectedrequestAtom.reportWrite(value, super.selectedrequest, () {
      super.selectedrequest = value;
    });
  }

  final _$gettingrequestsAtom = Atom(name: '_RequestState.gettingrequests');

  @override
  bool get gettingrequests {
    _$gettingrequestsAtom.reportRead();
    return super.gettingrequests;
  }

  @override
  set gettingrequests(bool value) {
    _$gettingrequestsAtom.reportWrite(value, super.gettingrequests, () {
      super.gettingrequests = value;
    });
  }

  final _$selectedfilterAtom = Atom(name: '_RequestState.selectedfilter');

  @override
  String get selectedfilter {
    _$selectedfilterAtom.reportRead();
    return super.selectedfilter;
  }

  @override
  set selectedfilter(String value) {
    _$selectedfilterAtom.reportWrite(value, super.selectedfilter, () {
      super.selectedfilter = value;
    });
  }

  final _$getRequestsAsyncAction = AsyncAction('_RequestState.getRequests');

  @override
  Future<dynamic> getRequests() {
    return _$getRequestsAsyncAction.run(() => super.getRequests());
  }

  final _$uploadRequestAsyncAction = AsyncAction('_RequestState.uploadRequest');

  @override
  Future<dynamic> uploadRequest(
      String title, String content, String image, String type) {
    return _$uploadRequestAsyncAction
        .run(() => super.uploadRequest(title, content, image, type));
  }

  final _$setRequestAsyncAction = AsyncAction('_RequestState.setRequest');

  @override
  Future<dynamic> setRequest(dynamic r) {
    return _$setRequestAsyncAction.run(() => super.setRequest(r));
  }

  final _$_RequestStateActionController =
      ActionController(name: '_RequestState');

  @override
  void filterRequests(String s) {
    final _$actionInfo = _$_RequestStateActionController.startAction(
        name: '_RequestState.filterRequests');
    try {
      return super.filterRequests(s);
    } finally {
      _$_RequestStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
requests: ${requests},
selectedrequest: ${selectedrequest},
gettingrequests: ${gettingrequests},
selectedfilter: ${selectedfilter}
    ''';
  }
}
