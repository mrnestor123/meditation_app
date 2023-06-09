
//TODO: CREAR CLASE REQUESTS CON TODA LA FUNCIONALIDAD DE USERSTATE PASADA AQUI


import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/domain/entities/notification_entity.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/presentation/mobx/actions/error_helper.dart';
import 'package:mobx/mobx.dart';

import '../../../domain/entities/stage_entity.dart';

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
  String selectedfilter = 'Date';

  List<String> filters = ['Date','Votes'];

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
  Future getRequests({String coduser}) async{
    requests.clear();
    gettingrequests = true;
    Either<Failure, List<Request>> res = await repository.getRequests(coduser: coduser);

    foldResult(
      result: res,
      onSuccess: (requests) {
        this.requests = requests;
        gettingrequests = false;
        filterRequests('Date');
      },
    );
  }

  Future updateRequest(Request r, bool like, [Comment comment, User u]) async{
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
        comment: comment.comment, date: DateTime.now(),
        username: user.nombre, userimage: user.image, coduser: user.coduser, user:user
      );
      c.images = comment.images;
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
  Future<Request> uploadRequest( String title, String content, String  image, String type, [dynamic stage]) async{
   
    Request  r = new Request(
      coduser: user.coduser, username:user.nombre, 
      userimage:user.image,
      content: content, title: title, state:'open', type: type,
      image: image
    );

    if(stage != null) {
      r.stagenumber =  stage;
    }
    
    requests.insert(0,r);
    //requests.add(r);
    Either<Failure,void> res = await repository.uploadRequest(r);
    bool hasFailed = false;

    // ESTO AUN VA CON EL MODELO ANTIGUO
    foldResult(
      result: res,
      onSuccess: (void v) {
        print('bien');
      },   
    );

    if(!res.isLeft()){
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
      foldResult(
        result: either,
        onSuccess:(r) { 
          if(r.cod != null && r.title != null){
            gettingrequests = false;
            if(r.comments.length > 0){
              r.comments.sort((Comment a,Comment b){
                if(a.date == null && b.date == null){
                  return 0;
                }else if(a.date == null){
                  return -1;
                }else if(b.date == null){
                  return 1;
                }else {
                  return a.date.compareTo(b.date);
                }
              });
            }
            selectedrequest = r;

            if(user.notifications !=  null &&  user.notifications.length >  0){

              List <Notify> notifications = user.notifications.where((element) => element.codrequest == cod).toList();

              for(Notify not in notifications){
                if(!not.seen){
                  viewNotification(not);
                }
              }
            }
          }
        }
      );
    }else {
      selectedrequest = r;
    }
  }

  Future uploadToFeed({Request r}) async {

    Either<Failure,void> res = await repository.uploadRequest(r);

    // ESTO AUN VA CON EL MODELO ANTIGUO
    foldResult(
      result: res,
      onSuccess: (void v) {
        print('bien');
      },   
    );
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

  @action
  Future getStageRequests({Stage s})async {
    requests.clear();
    gettingrequests = true;

    Either<Failure, List<Request>> res = await repository.getStageRequests();

    foldResult(
      result: res,
      onSuccess: (requests) {
        this.requests = requests;
        gettingrequests = false;
        filterRequests('Date');
      },
    );
  }


}