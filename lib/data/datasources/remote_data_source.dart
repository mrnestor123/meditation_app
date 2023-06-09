import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/message.dart';
import 'package:meditation_app/domain/entities/notification_entity.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../../domain/entities/action_entity.dart';
import '../../domain/entities/meditation_entity.dart';

//This will use the flutter database.
abstract class UserRemoteDataSource {
  // sacamos el objeto referencia

  /// Logins a user to the DataBase
  /// Throws a [ServerException] for all error codes.
  UserRemoteDataSource();

  /*
  * 
  * USER CONTROLLER !!!
  **/
  Future<UserModel> loginUser({User usuario, String coduser });

  Future<UserModel> registerUser({var usuario});

  Future <List<UserModel>> getUsers(UserModel u);

  Future <UserModel> getUser(String cod, [bool expand]);

  Future updateUser({UserModel user, DataBase data, dynamic toAdd, String type,  DoneContent done});
  
  //We get all the users data
  Future<DataBase> getData();

  Future getActions(UserModel u);

  Future uploadFile({XFile image,FilePickerResult audio, XFile video, UserModel u});

  Future <List<Request>> getRequests({String coduser});

  Future updateRequest(Request r, [List<Notify> n, Comment c]);
  

  Future updateNotification(Notify n);

  Future uploadRequest(Request r);

  Future<Request> getRequest(String cod);

  Future <List<UserModel>> getTeachers();

  Future sendMessage(Message m);

  Future addAction({UserAction a});


  Future addMeditationReport({Meditation m, MeditationReport report, UserModel user});

  Future sendQuestion({String coduser, String question});

  Future setUsername({String coduser, String username});

  Future getContent(String cod);

  Future getFeed();

}

// QUITAR ESTO PARA EL FUTURO
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}



class UserRemoteDataSourceImpl implements UserRemoteDataSource {

  // CREAR TOKENS YO MISMO PARA LA  SIGUIENTE VERSIÓN !!!
  String token;
  User firebaseUser;

  bool downloadedToken = false;
  //final appCheck = FirebaseAppCheck.instance;
  var nodejs ;
  Future<String> tokenGet;
  

  UserRemoteDataSourceImpl() {
    HttpOverrides.global = new MyHttpOverrides();
   // nodejs = 'https://us-central1-the-mind-illuminated-32dee.cloudfunctions.net/default';
    
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        // HACEMOS LOGIN ANÓNIMO !!!
        FirebaseAuth.instance.signInAnonymously();
        firebaseUser = user;
        print('User is logged in anonymously');
      } else {
        firebaseUser = user;
        print('User is signed in!');
      }
    });
    
    nodejs = 'http://localhost:5001/the-mind-illuminated-32dee/us-central1/default';
  
  }

  Future<dynamic> api_call(uri, { String method = 'GET', Object body, bool omitErrors = false}) async  {
    // http request   
    var url = Uri.parse(uri);
    http.Response response;

    if(firebaseUser == null){
      throw ServerException(error: 'Access denied');
    } else {
      token = await firebaseUser.getIdToken();
    }
    
    if (token == null) throw ServerException(error: 'Access denied');
    
    Map <String,String> headers = {"X-Firebase-Token": token};

    if(method == 'GET'){
      response = await http.get(url, headers: headers).timeout(
        const Duration(seconds:  20),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response('Connection timed out', 400); 
        }
      );
    }else if(method == 'PUT'){
      response = await http.put(url,body: body, headers: headers).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response('Connection timed out', 400); 
        }
      );
    }else if(method == 'POST'){
      response = await http.post(url,body: body, headers: headers).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response('Connection timed out', 400); 
        }
      );
    }else if(method == 'DELETE'){
      response = await http.delete(url, headers: headers).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response('Connection timed out', 400); 
        }
      );
    }else if(method =='PATCH'){
      response = await http.patch(url,body: body, headers: headers).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response('Connection timed out', 400); 
        }
      );
    }else {
      throw ServerException(error: 'Method not allowed');
    }

    if((response.statusCode == 400 || response.statusCode == 404 || 
      response.statusCode  == 403 || response.statusCode == 401) && !omitErrors) {
      dynamic body = json.decode(response.body);
      throw ServerException(
        error: body['message'] != null && body['message'] is String ? body['message'] : 'ERROR'
      );
    }else {
      return response.body;
    }
  }

  /*
  *
  * TODO EL TEMA DEL USUARIO!
  *
  */
  @override
  Future <UserModel> loginUser({User usuario, String coduser = ''}) async {
    // Vamos a hacer esto en el server !!
    try {
      if(firebaseUser != null) {
        String cod = firebaseUser.uid;
        String body = await api_call('$nodejs/users/user/$cod?connect=true', omitErrors: true );
        
        if(body == null || body.contains('User not found')){
          body = await api_call(
            '$nodejs/users/register', 
            method: 'POST', 
            body: {'id':firebaseUser.uid}
          );
        }

        UserModel u = UserModel.fromRawJson(body);

        print('created user');
        return u;
      
      }
    } catch (e) {
      print(e.toString());
      // COMPROBAR SI ES SERVEREXCEPTION
      throw ServerException(error: e is ServerException ? e.toString(): 'User not found');
    }
  }

  /// PODRÍAMOS PASAR SOLO EL CÓDIGO DEL USUARIO
  @override
  Future <UserModel> registerUser({var usuario}) async {
    // Sacamos la primera etapa
    // Esto se debería de sacar del getStage
    try {
      String body  = await api_call('$nodejs/users/register', method: 'POST', body: {'id':usuario.uid});
      UserModel u = UserModel.fromRawJson(body);
      return u;
    } catch (e) {
      throw ServerException(error: e is ServerException ? e.toString() : 'Could not sign up user');
    }
  }

  // REALMENTE NO ES
  Future <UserModel> getUser(dynamic coduser,[bool expand = false])async{
    try{
      String body = await api_call('$nodejs/users/user/$coduser?expand=$expand');
      UserModel u = UserModel.fromJson(json.decode(body),expand);

      return u;
    }catch(e){
      throw ServerException(error: e.toString());
    }
  }





  // se carga cada x tiempo las últimas acciones del usuario!
  Future getActions(UserModel u) async {
    try {
      String body = await api_call('$nodejs/users/actions/${u.coduser}');
      var actions = json.decode(body);
        
      if(actions['today'] != null && actions['today'].length > u.todayactions.length){
        u.setActions(actions['today'], true);
      }

      if(actions['thisweek'] != null && actions['thisweek'].length > u.thisweekactions.length){
        u.setActions(actions['thisweek'], false);
      }
    } catch (e){
      throw ServerException(error: e is ServerException ? e.toString(): 'Server error');
    }
  }

  @override
  Future<DataBase> getData({String token}) async  {
    try {
      String body = await api_call('$nodejs/database');
      DataBase d = new DataBase.fromJson(json.decode(body));
      return d;
    } catch (e) {
      print(e.toString());

      throw ServerException(error: e.toString());
    
    }
  }


  Future<List<UserModel>> getUsers(UserModel loggeduser) async {
    try {
      String body  = await api_call('$nodejs/users');
      List<UserModel> l = new List.empty(growable: true);
      var users = json.decode(body);

      for(var user in users){
        l.add(UserModel.fromJson(user,false));
      }

      l.sort((a, b) => b.userStats.timeMeditated.compareTo(a.userStats.timeMeditated));

      return l;
    } catch (e){
      throw ServerException(error: e is ServerException ? e.toString(): 'Server error');
    }
  }

  //DEBERIA DE LLAMARSE IMAGE
  // SUBIMOS IMÁGENES SIN NODE !!!!!!!!!!!!!!!
  Future<String> uploadFile({XFile image, FilePickerResult audio, XFile video, UserModel u}) async {
    try {
      
      Dio dio = new Dio();

      if(image == null){
        throw ServerException(error: 'No file selected');
      }

      String fileName = image.path.split('/').last;

      //create multipart request for POST or PATCH method

      
      FormData formData = FormData.fromMap({
        "file":  await MultipartFile.fromFile(image.path, filename:fileName, contentType: new MediaType('image','jpg') ),
      });

      var response = await dio.post(
        '$nodejs/users/upload/$fileName',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            "X-Firebase-AppCheck": token
          }
        )
      );

      //return profilepath;
    } catch(e){
      print({'ERROR UPLOADING IMAGE', e.toString()});
      throw ServerException(error: e is ServerException ? e.toString(): 'Server error');
    }
  }

  // ESTO SACARÁ L AS REQUESTS QUE NO TENGAN STAGENUMBER !!!!
  @override
  Future<List<Request>> getRequests({String coduser}) async {
    try {
      
      String body = await api_call('$nodejs/requests/user/$coduser');
      List<Request> requests = new List.empty(growable: true);
      for(var j in json.decode(body)){
        requests.add(Request.fromJson(j));
      }
      return requests;
    
    } catch(e){
      throw ServerException(error: e is ServerException ? e.toString(): 'Server error');
    }
  }

  Future<List<Request>> getFeed() async {
    try {
      List<Request> requests = new List.empty(growable: true);
      String body = await api_call('$nodejs/requests/feed');

      for(var j in json.decode(body)){
        requests.add(Request.fromJson(j));
      }

      return requests;
    
    } catch(e){
      throw ServerException(error: e is ServerException ? e.toString(): 'Server error');
    }

  }

  @override
  // ESTO HAY QUE PASARLO AL SERVER !!!!!
  Future updateUser({UserModel user, DataBase data, dynamic toAdd, String type, DoneContent done}) async {
    try{
      if(type != 'content' || type !='recording'){
        await api_call(
          '$nodejs/users/${user.coduser}', 
          method: 'PATCH', 
          body: json.encode(user.updateFields())
        );
      }
        
      if (type == 'meditate') {
        for(Meditation meditation in toAdd){
          await api_call(
            '$nodejs/users/meditate/finish/${user.coduser}', 
            method: 'POST', 
            body: json.encode(meditation.shortMeditation())
          );
        }
      }else if((type =='lesson' || type == null || type == 'content') && done != null){
        await api_call(
          '$nodejs/users/donecontent/${user.coduser}', 
          body: json.encode(done.toJson()),
          method: 'POST'
        );           
      }

      if(user.lastactions.length > 0){
        for(UserAction a in user.lastactions){
          addAction(a:a);
        }

        user.lastactions.clear();
      
      }

    }catch(e){  
      throw ServerException(error: e is ServerException ? e.toString() : 'Server error');
    }
  }

  @override
  Future addAction({UserAction a}) async{
    try {
      await api_call('$nodejs/users/action/${a.coduser}',
        method: 'POST',
        body: json.encode(a.toJson())
      );
    } catch(e){
      throw ServerException(error: e is ServerException ? e.toString(): 'Server error');
    }
  }

  

  Future updateRequest(Request r, [List<Notify> n, Comment c]) async{
    try {

      await api_call('$nodejs/requests/${r.cod}',
        method: 'PATCH',
        body: json.encode(r.toJson())
      );

      if(c != null){
        
        await api_call('$nodejs/requests/${r.cod}/comment',
          method: 'POST',
          body: json.encode(c.toJson())
        );

      }

      if(n != null && n.length > 0){

        for(var not in n){
          await api_call('$nodejs/requests/notification',
            method: 'POST',
            body: json.encode(not.toJson())
          );
        }

      }

    }catch(e) {
      throw ServerException(error: e is ServerException ? e.toString(): 'Server error');
    }
  }

  Future updateNotification(Notify n) async{
    try {
      await api_call('$nodejs/requests/notification/${n.cod}',
        method: 'PATCH',
        body: n.toJson()
      );
      
    } catch(e) {
      throw ServerException(error: e is ServerException ? e.toString(): 'Server error');
    }
  }

  Future uploadRequest(Request r) async{
     try {
      
      await api_call('$nodejs/requests/new',
        method: 'POST',
        body: json.encode(r.toJson())
      );

    } catch(e){
      throw ServerException(error: e is ServerException ? e.toString(): 'Server error');
    }
  }

  // PORQUE SE SIGUE PASANDO LOS USUARIOS !!!!
  Future sendMessage(Message m) async {
    try {

      await api_call('$nodejs/sendmessage/new',
        method: 'POST',
        body: json.encode(m.toJson())
      );
      
    } catch(e) {
      
      throw ServerException(error: e is ServerException ? e.toString(): 'Server error');
    }
  }

  @override
  Future<Request> getRequest(String cod) async{
    try {
      
      String body = await api_call('$nodejs/requests/$cod');
      Request request = new Request.fromJson(json.decode(body));
      return request;

    }catch(e) {
      throw ServerException(error: e is ServerException ? e.toString(): 'Server error');
    }
  }

  @override
  //PASAR ESTA FUNCION AL SERVIDOR
  Future<List<UserModel>> getTeachers() async { 
    try {

      String body = await api_call('$nodejs/users?role=teacher');
      var users = json.decode(body);

      List<UserModel> teachers = new List.empty(growable: true);
      for(var user in  users){
        teachers.add(UserModel.fromJson(user,false));
      }

      return teachers;
    }catch(e) {
      throw ServerException(error: e is ServerException ? e.toString(): 'Server error');
    }
  }

  /*
  @override
  Future follow({UserModel user, UserModel followed, bool follows}) async{
    try {
      var url  =  Uri.parse('$nodejs/follow/${followed.coduser}');
      http.Response response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'coduser':user.coduser, 'follows': follows})
      ); 
      
      if(response.statusCode == 200){
        //UserModel newUser = UserModel.fromRawJson(response.body);
        //return newUser;
      }else{ 
        throw ServerException();
      }


    }catch(e){
      print({'FOLLOW',e});
      throw ServerException();
    }
  }

  
  @override
  Future takeLesson({UserModel user, Lesson l}) async{

    try {
      QuerySnapshot query = await database.collection('readlessons').where('coduser', isEqualTo: user.coduser).get();

      if(query.docs.length > 0){
        bool contains = false;

        Map<String,dynamic> docs = query.docs[0].data();

        if(docs['readlessons'] != null && !docs['readlessons'].contains(l.cod)){
          database.collection('readlessons').doc(query.docs[0].id).update({
            'readlessons': FieldValue.arrayUnion([l.cod])
          });
        }
      }else {
        database.collection('readlessons').add({
          'coduser': user.coduser,
          'readlessons':[l.cod]
        });
      }

    } catch(e){
      print({'TAKELESSON',e});
      throw ServerException();
    }

  }

  @override
  Future<List<Chat>> getChats({UserModel user}) async {

    try{
      var url = Uri.parse('$nodejs/messages/${user.coduser}/new');
      
      http.Response response = await http.get(url).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          // debería throwear una exception
          // Time has run out, do what you wanted to do.
          return http.Response('Error', 400); 
        },
      );

      if(response.statusCode == 200){
        List<Chat> chats = new  List.empty(growable:true);
        List<dynamic> jsonResponse = json.decode(response.body);
        
        
        jsonResponse.forEach((chat){
          chats.add(Chat.fromJson(chat, user));
        });

        return chats;       
      }

      throw ServerException();
    }catch(e) {
      print({'Exception', e.toString()});
      throw ServerException();
    }
  }


  // AQUÍ DEBERÍAMOS DEVOLVER UN CHAT ????
  @override
  Future<Stream<List<Message>>> startConversation({UserModel sender,String receiver}) async {
    try{
      //ESTO DEPURARLO
      QuerySnapshot query = await database.collection('chats').where('shortusers.${sender.coduser}',isEqualTo:true)
      .where('shortusers.$receiver',isEqualTo:true).get();


      if(query.docs.length > 0){
        String documentId = query.docs[0].id;
        // habra que añadir solo los mensajes que no sean enviados por mi no??
        database.collection('chats').doc(documentId).collection('messages').snapshots().listen((snapshot) {
          if(snapshot.docs.isNotEmpty){
            var messages = snapshot.docs;
            List<Message> m = new List.empty(growable: true);
            
            for(var message in messages){
              m.add(Message.fromJson(message.data()));
            }

            _chatController.add(m);
          }
        });

        return _chatController.stream;
      }

      throw ServerException();
    }catch(e) {
      print({'Exception', e.toString()});
      throw ServerException();
    }
  }

  // Lioso!! mejor que sean dos strings !!!
  @override
  Future<Chat> getChat({UserModel sender, String receiver}) async{
    var url = Uri.parse('$nodejs/messages/${sender.coduser}/$receiver/new');
    http.Response response = await http.get(url).timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        // debería throwear una exception
        // Time has run out, do what you wanted to do.
        return http.Response('Error', 400); 
      },
    );


    if(response.statusCode == 200){
      return Chat.fromJson(json.decode(response.body), sender);    
    }

    // TODO: implement getChat
    throw ServerException();
  }
  
  
  
  @override
  Future createRetreat({Retreat r}) {
    try{
      //database.collection('retreats').add(r.toJson());
    }catch(e){
      print({'Exception', e.toString()});
      throw ServerException();
    }
  }
  */
  
  
  
  @override
  Future addMeditationReport({Meditation m,  MeditationReport report, UserModel  user}) async{
    try {
      
      await api_call(
        '$nodejs/users/meditate/report/${user.coduser}',
        method: 'PUT',
        body: json.encode({
          'cod':m.cod,
          'report': report.toJson()
        })
      );

      return true;  
    }catch(e){
      throw ServerException(error: e is ServerException ? e.toString(): 'Server error');
    }
  }
  
  @override
  Future sendQuestion({String coduser, String question}) async{

    try {
      await api_call(
        '$nodejs/users/question',
        method: 'POST',
        body: json.encode({
          'coduser': coduser,
          'question': question,
          'date': DateTime.now().millisecondsSinceEpoch
        })
      );
    }catch(e){
      throw ServerException(error: e is ServerException ? e.toString(): 'Server error');
    }
  }
  
  @override
  Future setUsername({String coduser, String username}) async {
    // url to nodejs
    
    try{
      await api_call(
        '$nodejs/users/setusername/$coduser',
        method: 'PUT',
        body: username
      );

      return true;
    }catch(e){
      throw ServerException(error: e is ServerException ? e.toString(): 'Server error');
    }
  }
  
  @override
  Future getContent(String cod) async {
     try{

      String body =  await api_call('$nodejs/content/$cod');

        
      Map<String,dynamic> res  =  json.decode(body);
        
      return Content.fromJson(res);
    } catch(e){
      throw ServerException(error: e is ServerException ? e.toString(): 'Server error');
    }
  }
}




