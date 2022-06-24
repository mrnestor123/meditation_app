
//TODO: CREAR CLASE REQUESTS CON TODA LA FUNCIONALIDAD DE USERSTATE PASADA AQUI


import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/domain/entities/notification_entity.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/presentation/mobx/actions/error_helper.dart';
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

    foldResult(
      result: res,
      onSuccess: (requests) {
        this.requests = requests;
        gettingrequests = false;
      },
    );
  }

  Future updateRequest(Request r, bool like, [String comment, User u]) async{
    Comment c;

    if(like != null){
      if(like){
        r.like(user.coduser);
      }else{
        r.dislike(user.coduser);
      }
    }else if(comment != null){
      c = new Comment(
        codrequest: r.cod,
        comment: comment,
        username: user.nombre, userimage: user.image, coduser: user.coduser, user:user);
      r.comment(c);
    }

    List<Notify> notifications = new List.empty(growable: true);

    // HAY QUE REVISAR LAS NOTIFICACIONES !!!
    // NOTIFICAMOS
    Notify n ;

    //  NOTIFICAMOS AL CREADOR DE LA REQUEST !!!
    if(r.coduser != user.coduser && like == null){
      notifications.add(new Notify(
        codrequest: r.cod,date: DateTime.now(),
        r:r, usernamedoing: user.nombre,
        coduser: r.coduser, requesttitle: r.title,
        type: comment != null ? 'comment': 'state',
        // LA IMAGEN PODRÍA CAMBIARSE !!
        userimage: user.image   
      ));
    } 

    List<String> notifiedUsers = new List.empty(growable: true);

    // NOTIFICAMOS TAMBIÉN A LA GENTE QUE HA COMENTADO
    if(r.comments != null && r.comments.length > 0){
      for(Comment c in r.comments){
        if(c.coduser != r.coduser && c.coduser != user.coduser && !notifiedUsers.contains(c.coduser)){
          notifiedUsers.add(c.coduser);
          notifications.add(new Notify(
            codrequest: r.cod,date: DateTime.now(),
            r:r, usernamedoing: user.nombre,
            coduser: c.coduser, requesttitle: r.title,
            // LIKE ???
            type: comment != null ? 'comment': 'state',
            userimage: user.image   
          ));
        }
      }
    }

    Either<Failure, void> res = await repository.updateRequest(r,notifications,c);

    if(res != null){
      foldResult(
        result: res,
        onSuccess: (void v) {
          print('bien');
        },   
      );
    }
  }

  @action
  Future<Request> uploadRequest( String title, String content, String  image, String type) async{
    Request  r = new Request(
      coduser: user.coduser, username:user.nombre, userimage:user.image,
      type:type, content: content, title: title, state:'open');
    requests.add(r);
    //requests.add(r);
    Either<Failure,void> res = await repository.uploadRequest(r);
    bool hasFailed = false;

    if(res != null){
      res.fold((f) {
        _mapFailureToMessage(f);
        hasFailed = true;
      }, 
      (r) => print('bien'));
    }

    if(!hasFailed){
      return r;
    }else {
      return null;
    }
  }

  @action
  Future setRequest({String cod,Request r})async {

    if(cod != null){
      gettingrequests = true;
      Either<Failure,Request> either = await repository.getRequest(cod);
      //HACER ALGO CON EL ERROR
      either.fold(
        (l) => null, 
        (r) { 
          if(r.cod != null && r.title != null){
            gettingrequests = false;
            selectedrequest = r;
          }
        }
      );
    }else {
      selectedrequest = r;
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