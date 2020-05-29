import 'package:firebaseauthenticationsystem/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SpinKitRotatingCircle(
          color: Colors.green,
          size: 50.0,
        ),
      ),
    );
  }
}
