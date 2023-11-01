import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:tech_a_thon/screen/HomePage.dart';
import 'package:tech_a_thon/screen/SignUp.dart';
import 'package:tech_a_thon/screen/home.dart';
import 'package:tech_a_thon/screen/list_user_memory.dart';
import 'package:tech_a_thon/screen/login.dart';

class authGate extends StatelessWidget {
  const authGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            final _auth =FirebaseAuth.instance;
            var uemail=_auth.currentUser!.uid;
            // home_Demo(email: uemail.toString());
            return userMemory();
          }
          else{
            return LoginPage();
          }
        },
      ),
    );
  }
}
