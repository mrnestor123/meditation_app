import 'package:mobx/mobx.dart';

part 'menu_state.g.dart';

class MenuState extends _MenuState with _$MenuState {
  MenuState({String sidebarRoute, int bottomenuindex})
      : super(sidebarRoute: sidebarRoute, bottomenuindex: bottomenuindex);
}

abstract class _MenuState with Store {
  @observable
  String sidebarRoute;

  @observable
  int bottomenuindex;

  _MenuState({this.sidebarRoute, this.bottomenuindex});

  @action
  Future switchbottommenu({int index}) {
    bottomenuindex = index;
  }

  @action 
  Future switchsidebarmenu({String route}){
    sidebarRoute = route;
  }
}
