import 'package:firebaseauthenticationsystem/models/user_model.dart';
import 'package:firebaseauthenticationsystem/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../shared/constants.dart';

class PhoneLoginScreen extends StatefulWidget {

  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> with SingleTickerProviderStateMixin {

  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool isLoading;
  PageController controller;
  TextEditingController textEditingController;



  //text field state
  String _phoneNo;
  String _otp;
  String error = '';
  String text = '';

   @override
  void initState() {
    super.initState();
    isLoading = false;
    controller = PageController(initialPage: 0,);
    textEditingController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    if(user == null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50.0),
          child: PageView(
            controller: controller,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              phonenoPage(context),
              otpPage(context),
            ],
          ),
        ),
      );
    } else {
      Navigator.maybePop(context);
      return HomePage();
    }
  }

  Widget phonenoPage(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: Icon(Icons.keyboard_backspace, color: Colors.white, size: 25,),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        SizedBox(height: 20,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0,),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Enter phone number',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text(
                          'India',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '+91',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            VerticalDivider(color: Colors.red, thickness: 1,),
                            Expanded(
                              child: TextFormField(
//                                    maxLength: 10,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                ),
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Phone Number',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[200],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    border: InputBorder.none
                                ),
                                validator: (val) => (val.length != 10 || val.isEmpty)
                                    ? 'Invalid Phone Number'
                                    : null,
                                onChanged: (val) {
                                  setState(() => _phoneNo = val);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: 120,
                      child: MaterialButton(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),),
                        child: Text(
                          'NEXT',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                        color: Colors.white,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            FocusScope.of(context).unfocus();
                            controller.animateToPage(1, duration: Duration(milliseconds: 250), curve: Curves.bounceIn);
                            dynamic result = await _authService.verifyPhone(context, '+91$_phoneNo');
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 22.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget otpPage(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: Icon(Icons.keyboard_backspace, color: Colors.white, size: 25,),
            onPressed: () => controller.jumpToPage(0),
          ),
        ),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Enter OTP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: PinCodeTextField(
            textInputType: TextInputType.number,
            length: 6,
            onSubmitted: (typedotp) =>print(typedotp),
            autoDisposeControllers: false,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            obsecureText: false,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              selectedFillColor: Colors.white.withOpacity(0.3),
              selectedColor: Colors.white,
              inactiveColor: Colors.white,
              activeColor: Colors.white,
              inactiveFillColor: Colors.white.withOpacity(0.3),
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 55,
              fieldWidth: 40,
              activeFillColor: Colors.white.withOpacity(0.3),
            ),
            animationDuration: Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            enableActiveFill: true,
            controller: textEditingController,
            onCompleted: (v) {
              print("Completed");
            },
            onChanged: (value) {
              print(value);
              setState(() {
                text = value;
              });
            },
            beforeTextPaste: (text) {
              print("Allowing to paste $text");
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
          ),
        ),
        SizedBox(height: 20,),
        isLoading ? SpinKitRing(color: Colors.green) : Container(
          width: 120,
          padding: EdgeInsets.symmetric(vertical: 5),
          child: MaterialButton(
            padding: EdgeInsets.symmetric(vertical: 5),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),),
            child: Text(
              'SUBMIT',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
            color: Colors.white,
            onPressed: () async {
              FocusScope.of(context).unfocus();
              setState(() => isLoading = true);
              _authService.otp = Future.value(text);
              await _authService.getOtp(context).whenComplete(() {
                setState(() => isLoading = false);
              });
            },
          ),
        ),
      ],
    );
  }

}
