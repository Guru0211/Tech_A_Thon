import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_a_thon/Service/backend.dart';
import 'package:tech_a_thon/screen/allUser.dart';
import 'package:tech_a_thon/screen/login.dart';

class home_Demo extends StatefulWidget {
  String email;
  home_Demo({required this.email});

  @override
  State<home_Demo> createState() => _home_DemoState(useremail: email);
}

class _home_DemoState extends State<home_Demo> {
  FirebaseAuth _auth=FirebaseAuth.instance;
  String useremail;
  _home_DemoState({required this.useremail});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Hello")),
    body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection("user").snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return const Text("Error");
        }
        if(snapshot.connectionState==ConnectionState.waiting){
          return const CircularProgressIndicator();
        }
          return ListView(
            children: snapshot.data!.docs.map<Widget>((doc)=>buildList(doc)).toList(),
          );

      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () async{
        final back_in=Provider.of<backend>(context,listen: false);
        String res=await back_in.Sign_out();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
        Navigator.pop(context,MaterialPageRoute(builder: (context) => LoginPage(),));

        
      },
      child: Icon(Icons.login_outlined),
    ),
    );
  }
  Widget buildList(DocumentSnapshot documentSnapshot){
    Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
    if (data == null) {
      return Container(); // Handle null data gracefully
    }

    String? userEmail = data['Username'];
    // print( _auth.currentUser?.email);
    if (userEmail == null || _auth.currentUser?.email == data['UserEmail']) {
      return Container(); // Handle null email or current user's email
    }

    return ListTile(
      title: Text(userEmail),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => allUser(UserName: data['Username'],),));
      },
    );
  }
}
