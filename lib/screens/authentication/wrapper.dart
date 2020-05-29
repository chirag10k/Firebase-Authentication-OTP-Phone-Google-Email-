import 'package:firebaseauthenticationsystem/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../enums/connectivity_status.dart';
import '../../models/user_model.dart';
import '../home/home_screen.dart';
import '../offline_screen.dart';
import 'auth_screen.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final connectionStatus = Provider.of<ConnectivityStatus>(context);
    //return either Home or Authenticate Screen
    if(connectionStatus == ConnectivityStatus.Offline)
      return OfflineScreen();
    else if(user != null && connectionStatus != ConnectivityStatus.Offline)
      return HomePage();
    else if (user == null)
      return AuthScreen();
    else
      return Loading();
  }
}
