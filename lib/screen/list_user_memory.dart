import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_a_thon/screen/detail.dart';
import 'package:tech_a_thon/screen/newMemory.dart';
import 'package:tech_a_thon/Service/backend.dart';

class userMemory extends StatefulWidget {
  const userMemory({Key? key}) : super(key: key);

  @override
  State<userMemory> createState() => _userMemoryState();
}

class _userMemoryState extends State<userMemory> {
  FirebaseAuth _auth=FirebaseAuth.instance;
  String uid1=FirebaseAuth.instance.currentUser!.uid.toString();
  @override
  Widget build(BuildContext context) {
    final m=TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("Memories"),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent[100],
      actions: [
        // IconButton(onPressed: (){
        //   showSearch(context: context, delegate: Mysearchdel());
        // }, icon: const Icon(Icons.search)),
        IconButton(onPressed: () async{
          final back_in= Provider.of<backend>(context,listen: false);
          await back_in.Sign_out();
        }, icon: Icon(Icons.login_outlined)),
        ],),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("memory").doc(uid1).collection("message").orderBy('date').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Text("Error");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return const CircularProgressIndicator();
          }
          return ListView(
            children:snapshot.data!.docs.map<Widget>((doc)=>buildList(doc)).toList(),
          );

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  newMemory(),));
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
  Widget buildList(DocumentSnapshot documentSnapshot){
    Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
    if (data == null) {
      return Container(); // Handle null data gracefully
    }
    String? userdis=data['Discription'];
    String? userloc=data['Location'];
    var img_url=data['image_url'];
    var date =data['date'];
    if (userdis == "" || date=="") {
      return Container(); // Handle null email or current user's email
    }
    // String? userEmail = data['Username'];
    // // print( _auth.currentUser?.email);
    // if (userEmail == null || _auth.currentUser?.email == data['UserEmail']) {
    //   return Container(); // Handle null email or current user's email
    // }

    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => detail(des: userdis,Location: userloc,Date: date.toString(),img_url:img_url),));
      },
      trailing: ElevatedButton(onPressed: () async{
        String documentId;
        var collection = FirebaseFirestore.instance.collection('memory').doc(_auth.currentUser!.uid.toString()).collection("message");
         QuerySnapshot querySnapshot = await collection
            .where('date', isEqualTo: date)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          // Access the first matching document ID
         documentId = querySnapshot.docs[0].id;
          print('Document ID: $documentId');
        } else {
          documentId="";
          print('No matching documents found.');
        }
        await collection
            .doc(documentId)
            .update({'date' : ''}) // <-- Updated data
            .then((_) => print('Success'))
            .catchError((error) => print('Failed: $error'));
        setState(() {

        });
      }, child: Icon(Icons.delete)),
      // trailing: Row(
      //   children: [
      //     Text(date),

      //   ],
      // ),
      leading: Image.network(img_url),
      title: Text(userdis!),
      subtitle: Text(userloc! +"  "+ date),
      // onTap: () {
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => allUser(UserName: data['Username'],),));
      // },
    );
  }

}

// class Mysearchdel extends SearchDelegate{
//
// }
