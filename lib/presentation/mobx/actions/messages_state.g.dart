// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MessagesState on _MessagesState, Store {
  final _$messagesAtom = Atom(name: '_MessagesState.messages');

  @override
  Map<User, List<Message>> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(Map<User, List<Message>> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  final _$usersAtom = Atom(name: '_MessagesState.users');

  @override
  List<User> get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(List<User> value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
    });
  }

  final _$selectedMessagesAtom = Atom(name: '_MessagesState.selectedMessages');

  @override
  List<Message> get selectedMessages {
    _$selectedMessagesAtom.reportRead();
    return super.selectedMessages;
  }

  @override
  set selectedMessages(List<Message> value) {
    _$selectedMessagesAtom.reportWrite(value, super.selectedMessages, () {
      super.selectedMessages = value;
    });
  }

  final _$selecteduserAtom = Atom(name: '_MessagesState.selecteduser');

  @override
  User get selecteduser {
    _$selecteduserAtom.reportRead();
    return super.selecteduser;
  }

  @override
  set selecteduser(User value) {
    _$selecteduserAtom.reportWrite(value, super.selecteduser, () {
      super.selecteduser = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_MessagesState.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$realTimeMessagesAtom = Atom(name: '_MessagesState.realTimeMessages');

  @override
  List<Message> get realTimeMessages {
    _$realTimeMessagesAtom.reportRead();
    return super.realTimeMessages;
  }

  @override
  set realTimeMessages(List<Message> value) {
    _$realTimeMessagesAtom.reportWrite(value, super.realTimeMessages, () {
      super.realTimeMessages = value;
    });
  }

  final _$sendMessageAsyncAction = AsyncAction('_MessagesState.sendMessage');

  @override
  Future<dynamic> sendMessage({String type, String text, User from}) {
    return _$sendMessageAsyncAction
        .run(() => super.sendMessage(type: type, text: text, from: from));
  }

  final _$getMessagesAsyncAction = AsyncAction('_MessagesState.getMessages');

  @override
  Future<dynamic> getMessages({User user}) {
    return _$getMessagesAsyncAction.run(() => super.getMessages(user: user));
  }

  final _$selectChatAsyncAction = AsyncAction('_MessagesState.selectChat');

  @override
  Future<dynamic> selectChat(User receiver, [User sender, Chat chat]) {
    return _$selectChatAsyncAction
        .run(() => super.selectChat(receiver, sender, chat));
  }

  @override
  String toString() {
    return '''
messages: ${messages},
users: ${users},
selectedMessages: ${selectedMessages},
selecteduser: ${selecteduser},
isLoading: ${isLoading},
realTimeMessages: ${realTimeMessages}
    ''';
  }
}
