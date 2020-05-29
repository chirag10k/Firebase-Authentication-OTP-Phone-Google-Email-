import 'package:firebaseauthenticationsystem/screens/authentication/phone_login_screen.dart';
import 'package:firebaseauthenticationsystem/services/auth_service.dart';
import 'package:firebaseauthenticationsystem/shared/constants.dart';
import 'package:firebaseauthenticationsystem/shared/signin_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'email_login_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  bool isLoading;

  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40,),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
              child: Text('TITLE', style: TextStyle(color: Colors.white, fontSize: 24),),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Hello',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                    ),
                  ),
                  Text(
                    'There',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 50,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    'Continue with',
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 20,
                      letterSpacing: 2
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PhoneLoginScreen(),
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
                                'PHONE NUMBER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
//                        PhoneSigninButton(context, 'PHONE NUMBER', PhoneLoginScreen()),
                        SizedBox(height: 10,),
                        isLoading ? SpinKitRing(color: Colors.green) : MaterialButton(
                          onPressed: () {
                            setState(() => isLoading = true);
                            authService.signInWithGoogle().whenComplete(() {
                              setState(() => isLoading = false);
                            });
                          },
                          padding: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.google),
                              SizedBox(width: 10,),
                              Text(
                                'GOOGLE',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        EmailSigninButton(context, 'EMAIL', EmailLoginScreen()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
