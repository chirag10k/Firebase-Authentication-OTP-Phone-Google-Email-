import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../shared/constants.dart';

class SignupScreen extends StatefulWidget {

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool otpVerified = false;

  //text field state
  String _email = '';
  String _password = '';
  String _phoneNo = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.black.withOpacity(0.9),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50,),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.keyboard_backspace, color: Colors.white, size: 25,),
                ),
                Spacer(),
                Text(
                  'Create account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: 20,),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'What\'s your email?',
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
                    padding: const EdgeInsets.symmetric(horizontal: 20,),
                    child: TextFormField(
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),
                      decoration: textInputDecoration.copyWith(
                        border: InputBorder.none,
                      ),
                      validator: (val) => (!val.contains('@') || val.isEmpty || (!val.contains('.com')))
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
                      'Create a password',
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
                    padding: const EdgeInsets.symmetric(horizontal: 20,),
                    child: TextFormField(
                      obscureText: true,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),
                      decoration: textInputDecoration.copyWith(
                          border: InputBorder.none
                      ),
                      validator: (val) => (val.length < 10 || val.isEmpty )
                          ? 'Invalid Password'
                          : null,
                      onChanged: (val) {
                        setState(() => _password = val);
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  OutlineButton(
                    borderSide: BorderSide(
                        color: Colors.white
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        FocusScope.of(context).unfocus();
                        print('validated');
                        bool emailUsed = await _authService.getUserFromEmail(_email);
                        print(emailUsed);
                        if(emailUsed){
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Email Already in use'),
                                actions: <Widget>[
                                  FlatButton(onPressed: ()=> Navigator.pop(context), child: Text('OK'))
                                ],
                              );
                            }
                          );
                        } else {
                          _authService.createUserWithEmailAndPassword(_email, _password);
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
                          'SUBMIT',
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
      ),
    );
  }

}
