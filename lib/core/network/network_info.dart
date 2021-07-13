import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl();

  @override
  Future<bool> get isConnected async{
    var connectivityResult = await (Connectivity().checkConnectivity());

    if(connectivityResult != ConnectivityResult.none){
      return true;
    }else {
      return false;
    }

  }
}
