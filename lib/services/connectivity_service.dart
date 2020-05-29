import 'package:connectivity/connectivity.dart';

import '../enums/connectivity_status.dart';

class ConnectivityService{

  Stream<ConnectivityStatus> get onConnectivityChanged {
    return Connectivity().onConnectivityChanged.map(_getStatusFromResult);

  }

  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch(result){
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default :
        return ConnectivityStatus.Offline;
    }
  }

}