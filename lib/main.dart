import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'enums/connectivity_status.dart';
import 'models/user_model.dart';
import 'screens/authentication/wrapper.dart';
import 'services/auth_service.dart';
import 'services/connectivity_service.dart';

void main()=> runApp(new MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          value: AuthService().onAuthStateChanged,
        ),
        StreamProvider<ConnectivityStatus>.value(
          value: ConnectivityService().onConnectivityChanged,
        ),
      ],
      child: MaterialApp(
        title: 'Authentication System',
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}