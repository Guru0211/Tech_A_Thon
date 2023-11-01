import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class allUser extends StatefulWidget {
  String UserName;
  allUser({required this.UserName});

  @override
  State<allUser> createState() => _allUserState(UserName: UserName);
}

class _allUserState extends State<allUser> {
  String UserName;
  _allUserState({required this.UserName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(UserName),
      ),
    );
  }
}
