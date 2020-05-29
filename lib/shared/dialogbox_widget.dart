import 'package:flutter/material.dart';

Future<dynamic> userExistLogin(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("No active account found. Please Sign Up!",),
        actions: <Widget>[
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

Future<dynamic> userExistSignUp(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("User already exists!\n Please Proceed to Login"),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      }
  );
}

Future<dynamic> alertMessage(BuildContext context, String title,) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      }
  );
}