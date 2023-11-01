import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:tech_a_thon/Service/usermodel.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: camel_case_types
class backend extends ChangeNotifier{
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> google_login() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {

      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(
          credential);
      User? user = userCredential
          .user; // Access the User object from UserCredential
      if (user != null) {
        print("Signed in ${user.displayName}" ?? "No display name available");
      }
      // return user;
    } catch (error) {
      print("****");
      print(error);
      // return error;
    }
  }


  Future<String?> sign_in(String email, String pass) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: pass);

      return "Login Successfully";
    } on FirebaseAuthException catch (e) {
      String? a = e.message;
      // print(a);
      if (a == "A non-empty password must be provided") {
        return "Please enter the password";
      }
      if (a == "INVALID_LOGIN_CREDENTIALS" || a == "Error") {
        return "Incorrect Email Or Password";
      }
      if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email)) {
        return "Please Enter Valid Email Id";
      }
      if (a == "The email address is badly formatted.") {
        return "Please enter the Email";
      }
      return "Please enter the password";
    }
  }

  Future<String?> sign_up(String email, String pass, String name) async {
    try {
      if (name.isEmpty) {
        return "Enter the UserName";
      }
      UserCredential _cre =await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: pass);
      final firestore = FirebaseFirestore.instance;
      DocumentReference documentReference = firestore.collection('user').doc(
          email);
      await documentReference.set(
          userModel(username: name, useremail: email, password: pass,uid: _auth.currentUser!.uid.toString()).toJson());
      return "Created Successfully";
    } on FirebaseException catch (e) {
      if (e.message ==
          "The email address is already in use by another account.") {
        return "Email Id already exist ";
      }
      if (e.message == "The email address is badly formatted.") {
        return "Please enter the Email Id";
      }
      if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email)) {
        return "Please Enter Valid Email Id";
      }
      if (e.message == "A non-empty password must be provided") {
        return "Please enter the Password";
      }
      return "Invalid Email or Password";
    }
  }

  Future<String?> reset_password(String email) async {
    int flag = 0;
    try {
      final firestore = FirebaseFirestore.instance;

      // Reference to the collection you want to retrieve documents from
      QuerySnapshot querySnapshot = await firestore.collection('user').get();

      // Loop through the documents and access their data
      querySnapshot.docs.forEach((document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (document.id == email) {
          flag = 1;
        }
      });
      if (flag == 1) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        return "Recovery Email Send Successfully";
      }
      else {
        return "Email Not Found";
      }
    } on FirebaseException catch (e) {
      return "Email Not Found";
    }
  }


  Future<String> home_Username(String email) async {
    try {
      // Replace 'myCollection' with the name of your collection.
      // Replace 'documentID' with the actual ID of the document you want to read.
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot documentSnapshot = await firestore.collection('user')
          .doc(email)
          .get();

      if (documentSnapshot.exists) {
        // Access the data in the document.
        Map<String, dynamic> data = documentSnapshot.data() as Map<
            String,
            dynamic>;

        // Now, you can access individual fields from the document.
        String fieldValue = data['Username']; // Replace 'fieldName' with the actual field name in your document.
        return fieldValue;
      } else {
        return "'Document does not exist.";
      }
    } catch (e) {
      return "Error reading document: $e";
    }
  }
  Future<String> Sign_out() async{
    await FirebaseAuth.instance.signOut();
    return "SignOut Successfully";
  }
}