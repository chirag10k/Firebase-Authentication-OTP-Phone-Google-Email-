import 'package:firebaseauthenticationsystem/models/user_model.dart';
import 'package:firebaseauthenticationsystem/services/database_service.dart';
import 'package:firebaseauthenticationsystem/shared/constants.dart';
import 'package:firebaseauthenticationsystem/shared/get_user_details.dart';
import 'package:firebaseauthenticationsystem/shared/loading.dart';
import 'package:firebaseauthenticationsystem/shared/signout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

   @override
  Widget build(BuildContext context) {
    User user1 = Provider.of<User>(context);
    final DatabaseService _db = DatabaseService(user: user1);
    return StreamBuilder(
      stream: _db.userData,
      builder: (context, snapshot){
        User user = snapshot.data;
        _db.user = user;
        if(snapshot.hasData){
          if(user.gender == null) {
            print(user.gender);
            return GetUserDetails();
          }
          else
            return Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              color: backgroundColor,
              child: Center(
                child: Container(
                  height: 300,
                  width: 300,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Spacer(),
                          isLoading ? SpinKitRing(color: Colors.white) : MaterialButton(
                            elevation: 5,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            color: Colors.pink,
                            child: Text("Signout", style: TextStyle(fontSize: 20, color: Colors.white),),
                            onPressed: () {
                              setState(() => isLoading = true);
                              SignOut(context).whenComplete(() {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Hello ${user.name}!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        else {
          return Loading();
        }
      },
    );
  }
}
