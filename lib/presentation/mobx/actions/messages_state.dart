
 /*

import 'package:dartz/dartz.dart';
import 'package:meditation_app/domain/entities/message.dart';
import 'package:mobx/mobx.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/user_repository.dart';
import 'error_helper.dart';

part 'messages_state.g.dart';

class MessagesState extends _MessagesState with _$MessagesState {
  MessagesState({UserRepository repository}): super(repository: repository);
}

// CAMBIAR LAS STRINGS DE LOS ESTADOS AQUI TAMBIEN !!!!

abstract class _MessagesState with Store {
  UserRepository repository;

  @observable
  Map<User, List<Message>> messages = new Map();

  @observable
  List<User> users = new List.empty(growable: true);
    
  int selectedInterval;

  @observable
  List<Message> selectedMessages = new List.empty(growable: true);

  @observable
  User selecteduser;

  @observable 
  bool isLoading = false;

  Chat selectedChat;
  List<Chat> userChats = new List.empty(growable: true);

  @observable
  List<Message> realTimeMessages = new List.empty(growable: true);

  Stream<List<Message>> messagesStream;

  _MessagesState({this.repository});
 
  @action
  Future sendMessage({String type, String text, User from}) async {
    Message m = from.sendMessage(selectedChat.notMe['coduser'],type, text);
    realTimeMessages.insert(0,m);
    
    Either<Failure,void> userlist = await repository.sendMessage(message: m);

    if(!userChats.contains(selectedChat)){
      selectedChat.lastMessage = m;
      userChats.add(selectedChat);
    }

    foldResult(
      result: userlist,
    );

    return m;
  }

  // ESTO ES PARA ACEPTAR ESTUDIANTES
  void acceptStudent({Message message, bool confirm, User user}){
    Message reply = user.acceptStudent(message,confirm);
    var messages ={
      'accept': 'Has accepted your request to join his courses',
      'deny': 'Has denied your request to join his courses'
    };

    // MUCHAAAAAAAAAAS COSAAS
    repository.sendMessage(message: reply);
    repository.updateMessage(message: message);
    repository.updateUser(user: user);
   
  }

  @action
  Future getMessages({User user}) async{
    /*
    if(messages.isEmpty){
      messages = new Map();
      isLoading = true;
      /Either<Failure, List<Chat>> messagesres = await repository.getMessages(user:user);
        
      foldResult(
        result: messagesres,
        onSuccess: (result){
          if(result != null){
            userChats = result;
           // messages = result;
           // users = result.keys.toList()..sort(((User a,User b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase())));
            isLoading = false;
          }
        }
      );
    }*/
  }


  Future deleteMessage({Message message, User user}){
    message.deleted = true;
    user.messages.remove(message);
    repository.updateMessage(message: message);
  }

  @action 
  Future selectChat(User receiver, [User sender, Chat chat])async{ 
    isLoading = true;
    realTimeMessages.clear();

    if(receiver != null){
      selecteduser = receiver;
    }

    // es mensaje privado
    if(chat == null){
      //Either<Failure,Chat> chatres = await repository.getChat(sender: sender,receiver: receiver.coduser);

      //chatres.fold((l) => null, (r) => chat = r);
    }


    // si el chat ya existe sacamos sus mensajes
    if(chat != null){
      selectedChat = chat;

      // solo sacamos el stream si el chat no es nuevo !!!
      // CADA VEZ QUE ENTRA DEBERÍA DE REFRESCAR TAMBIEN??
      // receiver no esta siempre
      Either<Failure, Stream<List<Message>>> messagesres = await repository.startConversation(
        sender:sender, 
        receiver:chat.notMe['coduser']
      );
      
      foldResult(
          result: messagesres,
          onSuccess: (Stream<List<Message>>  result){
            messagesStream = result;
            isLoading = false;
            if(result != null){
              result.listen((messages){
                realTimeMessages = messages;
                realTimeMessages.sort((a,b)=> b.date.compareTo(a.date));
              }); 
            }
          }
        );
    } else {

      //PRIMERO habría que sacar el chat de la base de datos y si no existe crear uno nuevo !!
      selectedChat = new Chat(
        codchat: '',
        me: {
          'coduser':sender.coduser,
          'userimage':sender.image,
          'nombre':sender.nombre
        },
        notMe: {
          'coduser':receiver.coduser,
          'userimage':receiver.image,
          'nombre':receiver.nombre
        },
      );
      isLoading = false;
    }
  }
}

*/