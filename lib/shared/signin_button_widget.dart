import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget PhoneSigninButton(BuildContext context, String title, Widget widget) {
  return MaterialButton(
    onPressed: () => Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => widget,
      ),
    ),
    padding: EdgeInsets.symmetric(vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    color: Colors.green,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(FontAwesomeIcons.mobileAlt, color: Colors.white,),
        SizedBox(width: 10,),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}

Widget EmailSigninButton(BuildContext context, String title, Widget widget) {
  return OutlineButton(
    borderSide: BorderSide(
        color: Colors.white
    ),
    onPressed: () => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    ),
    padding: EdgeInsets.symmetric(vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.email, color: Colors.white,),
        SizedBox(width: 10,),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}