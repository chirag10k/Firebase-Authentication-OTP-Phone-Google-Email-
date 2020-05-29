import 'package:firebaseauthenticationsystem/models/user_model.dart';
import 'package:firebaseauthenticationsystem/screens/authentication/signup_screen.dart';
import 'package:firebaseauthenticationsystem/screens/home/home_screen.dart';
import 'package:firebaseauthenticationsystem/services/auth_service.dart';
import 'package:firebaseauthenticationsystem/shared/constants.dart';
import 'package:firebaseauthenticationsystem/shared/signin_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailLoginScreen extends StatefulWidget {
  @override
  _EmailLoginScreenState createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {

  String _email, _password;

  final AuthService _authService = AuthService();
  PageController controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0,);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    if(user == null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.black.withOpacity(0.9),
          width: MediaQuery
              .of(context)
              .size
              .width,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50,),
          child: PageView(
            controller: controller,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.keyboard_backspace, color: Colors.white,
                        size: 25,),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'EMAIL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0,),
                    child: Column(
                      children: <Widget>[
                        EmailSigninButton(context, 'SIGN UP', SignupScreen()),
                        SizedBox(height: 20,),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(color: Colors.white,),
                            ),
                            SizedBox(width: 10,),
                            Text('OR', style: TextStyle(color: Colors.white),),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Divider(color: Colors.white,),
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Email or username',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,),
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                  ),
                                  decoration: textInputDecoration.copyWith(
                                      border: InputBorder.none
                                  ),
                                  validator: (val) =>
                                  (!val.contains('@') || val.isEmpty ||
                                      (!val.contains('.com')))
                                      ? 'Invalid EMAIL'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => _email = val);
                                  },
                                ),
                              ),
                              SizedBox(height: 20,),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Password',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,),
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  obscureText: true,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                  ),
                                  decoration: textInputDecoration.copyWith(
                                      border: InputBorder.none
                                  ),
                                  validator: (val) =>
                                  (val.length != 10 || val.isEmpty)
                                      ? 'Invalid PASSWORD'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => _password = val);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                        OutlineButton(
                          borderSide: BorderSide(
                              color: Colors.white
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              FocusScope.of(context).unfocus();
                              print('validated');
                              bool emailUsed = await _authService
                                  .getUserFromEmail(_email);
                              print(emailUsed);
                              if (!emailUsed) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Email Not Registered!'),
                                        actions: <Widget>[
                                          FlatButton(onPressed: () =>
                                              Navigator.pop(context),
                                              child: Text('OK'))
                                        ],
                                      );
                                    }
                                );
                              } else {
                                _authService.signInWithEmailAndPassword(
                                    _email, _password);
                              }
                            }
                            else
                              print('not validated');
                          },
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
                                'LOG IN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      Navigator.maybePop(context);
      return HomePage();
    }
  }
}
