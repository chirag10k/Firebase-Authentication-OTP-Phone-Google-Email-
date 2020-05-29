import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class DatabaseService {
  User user;
  DatabaseService({this.user});

  static final Firestore _firestore = Firestore.instance;

  //Users Collection reference
  final CollectionReference userCollection = _firestore.collection('users');

  //map user snapshot to user data
  User userDataFromSnapshot(DocumentSnapshot snapshot){
    return User(
      uid: snapshot.data['uid'],
      name: snapshot.data['name'],
      email: snapshot.data['email'],
      phoneNo: snapshot.data['phonenumber'],
      gender: snapshot.data['gender'],
    );
  }

  //get user data stream from firebase
  Stream<User> get userData {
    return _firestore.collection('users').document(user.uid).snapshots()
        .map(userDataFromSnapshot);
  }

  Future setUserData() async {
    return await userCollection.document(user.uid).setData({
      'uid': user.uid,
      'name': user.name,
      'email': user.email,
      'phonenumber': user.phoneNo,
      'gender': user.gender,
    });
  }

  Future updateUserData(String name, String gender) async {
    if(name == null)
      name = user.name;
    return await userCollection.document(user.uid).setData({
      'name': name,
      'gender': gender,
    }, merge: true);
  }

}