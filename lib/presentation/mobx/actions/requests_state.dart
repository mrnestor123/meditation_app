
//TODO: CREAR CLASE REQUESTS CON TODA LA FUNCIONALIDAD DE USERSTATE PASADA AQUI


import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/domain/entities/notification_entity.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:mobx/mobx.dart';

part 'requests_state.g.dart';

class RequestState extends _RequestState with _$RequestState {
  RequestState({UserRepository repository}) : super(repository: repository);
}

abstract class _RequestState with Store {
  UserRepository repository;

  User user;
  
  @observable
  List<Request> requests = new List.empty(growable: true);

  @observable
  Request selectedrequest;

  String errorMessage;

  @observable
  bool gettingrequests= false;

  @observable 
  String selectedfilter = 'None';

  List<String> filters = ['None','Date','Votes'];

  _RequestState({this.repository});

  void setUser(User u){
    user = u;
  }
  
  void _mapFailureToMessage(Failure failure) {
    // Instead of a regular 'if (failure is ServerFailure)...'
    switch (failure.runtimeType) {
      case ServerFailure:
        errorMessage='Server failure';
        break;
      case CacheFailure:
        errorMessage = 'Cache failure';
        break;
      case LoginFailure: 
        errorMessage = failure.error != null ? failure.error : 'User not found in the database';
        break;
      default:
        errorMessage = 'Unexpected Error';
        break;
    }
  }

  //HACER UN REQUEST STATE ???????
  @action 
  Future getRequests() async{
    requests.clear();
    gettingrequests = true;
    Either<Failure, List<Request>> res = await repository.getRequests();

    res.fold(
    (Failure f) {
      _mapFailureToMessage(f);  
    },
    (List<Request> d) {
      gettingrequests = false;
      requests = d;
    });
  }

  Future updateRequest(Request r, bool like, [String comment, User u]) async{
    if(like != null){
      if(like){
        r.like(user.coduser);
      }else{
        r.dislike(user.coduser);
      }
    }else if(comment != null){
      Comment c = new Comment(comment: comment,username: user.nombre, coduser: user.coduser);
      r.comment(c);
    }

    Notify n;
    //  CON LOS LIKES NO SE NOTIFICA DE MOMENTO!!!
    if(r.coduser != user.coduser && like == null){
      n = new Notify(
        codrequest: r.cod,date: DateTime.now(),
        r:r,usernamedoing: user.nombre,
        coduser: r.coduser, requesttitle: r.title,
        type: comment != null ? 'comment': 'state',
        // LA IMAGEN PODRÍA CAMBIARSE !!
        userimage: user.image   
      );
    }

    Either<Failure, void> res = await repository.updateRequest(r,n);
    if(res != null){
      print(res);
      res.fold((f) => _mapFailureToMessage(f), 
      (r) => print('bien'));
    }
  }

  @action
  Future uploadRequest( String title, String content, String  image, String type) async{
    Request  r = new Request(
      coduser: user.coduser, username:user.nombre, userimage:user.image,
      type:type, content: content, title: title, state:'open');
    requests.add(r);
    //requests.add(r);
    Either<Failure,void> res = await repository.uploadRequest(r);
    if(res != null){
      res.fold((f) => _mapFailureToMessage(f), (r) => print('bien'));
    }
  }

  @action
  Future setRequest(dynamic r)async {
    if(r is Request){
      selectedrequest = r;
      gettingrequests = false;
    }else{
      gettingrequests = true;
      Either<Failure,Request> either = await repository.getRequest(r);
      //HACER ALGO CON EL ERROR
      either.fold(
        (l) => null, 
        (r) { 
          gettingrequests = false;
          selectedrequest = r;
        }
      );
    }
  }

  void viewNotification(Notify n){
    //HACER ESTO EN EL Notify
    n.view();

    //updateamos todas las notificaciones que estén en esa request
    for(Notify not in user.notifications){
      if(n.cod != not.cod && n.codrequest == not.codrequest){
        n.view();
        repository.updateNotification(not);
      }
    }

    repository.updateNotification(n);
  }

  @action
  void filterRequests(String s){
    if(s == 'Votes'){
      requests.sort((a,b)=>b.points-a.points);
    }else if(s=='Date'){
      requests.sort((a,b)=> b.date.compareTo(a.date));
    }
    selectedfilter = s;  
  }
}