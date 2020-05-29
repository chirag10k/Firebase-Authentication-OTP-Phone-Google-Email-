import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauthenticationsystem/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount googleAccount;
  DatabaseService _db = DatabaseService(user: null);

  String phoneNo, userEmail, userName;
  String verificationId, smsCode;
  String error;
  bool codeSent = false;
  bool manual = false;
  bool isNew;
  Future<String> otp;
  String otpstring;
  AuthCredential credential;

  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future<bool> getUserFromNo(String phoneNo) async {
    final QuerySnapshot snapshot = await userCollection.getDocuments();
    final List<DocumentSnapshot> documents = snapshot.documents;
    if(documents != null) {
      for(int i = 0; i < documents.length; i++ ){
        if(documents[i].data['phonenumber'] == phoneNo){
          return true;
        }
      }
    }
    return false;
  }

  Future getUserFromEmail(String email) async {
    final QuerySnapshot snapshot = await userCollection.getDocuments();
    final List<DocumentSnapshot> documents = snapshot.documents;
    if(documents != null) {
      for(int i = 0; i < documents.length; i++ ){
        if(documents[i].data['email'] == email){
          return true;
        }
      }
    }
    return false;
  }


  String getError() {
    return error;
  }

  //create user object based on firebase user
  User _userFromFirebase (FirebaseUser user) {
    return (user != null)
        ? User(
            uid: user.uid,
            name: user.displayName,
            email: user.email,
            phoneNo: user.phoneNumber,
            gender: null,
          )
        : null;
  }

  //user stream on auth state changes
  Stream<User> get onAuthStateChanged {
    return _auth.onAuthStateChanged
        .map(_userFromFirebase);
  }

  Future getOtp(BuildContext context) async {
    otpstring = await otp;
    credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: otpstring);
    signIn(context, credential);
  }

  Future<dynamic> verifyPhone(BuildContext context, String phoneNumber) async {
    phoneNo = phoneNumber;

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent phoneCodeSent = (String verId, [int forceCodeResend]) async {
      this.verificationId = verId;
    };

    final PhoneVerificationCompleted phoneVerificationCompleted = (AuthCredential phoneAuthCredential) {
      credential = phoneAuthCredential;
      signIn(context, phoneAuthCredential);
      print("Verification Completed");
      return ;
    };

    final PhoneVerificationFailed phoneVerificationFailed = (AuthException exception) {
      print('Error: ${exception.message}');
      error = exception.message;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        codeAutoRetrievalTimeout: autoRetrievalTimeout,
        codeSent: phoneCodeSent,
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
    );

  }

  Future signIn(BuildContext context, AuthCredential authCredential) async {
    try{
      AuthResult result = await _auth.signInWithCredential(authCredential);
      FirebaseUser user = result.user;
      _db.user = User(
        uid: user.uid,
        phoneNo: phoneNo,
      );
      if(user != null){
        isNew = result.additionalUserInfo.isNewUser;
        if(isNew)
          _db.setUserData();
      } else
        return user;
    } on PlatformException catch (e) {
      print(e.code);
      error = e.code;
      if(error == 'ERROR_INVALID_VERIFICATION_CODE'){
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('OTP entered is incorrect\nPlease try again!'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            }
        );
      }
      return;
    }
  }

  //sign in with google
  Future signInWithGoogle() async {
    try {
      googleAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleAccount.authentication;

      final AuthCredential _credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final AuthResult result = await _auth.signInWithCredential(_credential);
      final FirebaseUser firebaseUser = result.user;
      User user = _userFromFirebase(firebaseUser);
      _db.user = User(
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        name: firebaseUser.displayName,
        phoneNo: "+91xxxxxxxxxx"
      );

      if(user != null){
        isNew = result.additionalUserInfo.isNewUser;
        if(isNew)
          _db.setUserData();
      } else
        return user;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email address and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final FirebaseUser firebaseUser = result.user;
      User user = _userFromFirebase(firebaseUser);
      _db.user = User(
        uid: firebaseUser.uid,
        email: firebaseUser.email,
      );
      if(user != null){
        isNew = result.additionalUserInfo.isNewUser;
        if(isNew)
          _db.setUserData();
      } else
        return user;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //Sign up with email and password
  Future createUserWithEmailAndPassword(String email, String password) async {
    try {
      final AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final FirebaseUser firebaseUser = result.user;
      isNew = result.additionalUserInfo.isNewUser;
      User user = _userFromFirebase(firebaseUser);
      _db.user = User(
        uid: firebaseUser.uid,
        email: firebaseUser.email,
      );

      if(user != null){
        _db.setUserData();
      } else
        return user;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  //signout
  Future signOut() async {
    try{
      await _googleSignIn.disconnect().catchError((e){});
      await _googleSignIn.signOut().catchError((e){});
      await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //get Phone Sign Up Details
  getPhoneSignupDetails() {}


}