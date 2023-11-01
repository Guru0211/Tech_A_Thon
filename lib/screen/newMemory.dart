import 'dart:io';
import 'package:tech_a_thon/Service/memory_Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_a_thon/screen/list_user_memory.dart';

class newMemory extends StatefulWidget {
  const newMemory({Key? key}) : super(key: key);

  @override
  State<newMemory> createState() => _newMemoryState();
}

class _newMemoryState extends State<newMemory> {
  // DateTime now1 = new DateTime.now();
  DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,DateTime.now().hour,DateTime.now().minute);
  late int post_id=1;
  String img_url="https://firebasestorage.googleapis.com/v0/b/tech-a-thon-2ba54.appspot.com/o/images%2Fdefault_img.png?alt=media&token=5d155e6a-bd99-494c-8faf-f2d9764eedb6&_gl=1*b51pct*_ga*MTY0MTIyMjE3LjE2Nzc2NzMxNDI.*_ga_CW55HF8NVT*MTY5ODgxMjg2NC41MC4xLjE2OTg4MTMyMzAuNjAuMC4w";
  late String img2_url;
  XFile? file;
  XFile? image;
  FirebaseAuth _auth =FirebaseAuth.instance;
  String uid1=FirebaseAuth.instance.currentUser!.uid;
  ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    file= await picker.pickImage(source: media);

    setState(() {
      image = file;
    });
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [

                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  final dis= TextEditingController();
  final loc= TextEditingController();
  final img_name= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("AddMemories"+date.toString()),
      appBar: AppBar(title: Text("AddMemories"),
      backgroundColor: Colors.deepPurpleAccent[100]),
      body:Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              // Text(uid1.toString()),
              TextFormField(
                controller: dis,
                decoration: const InputDecoration(
                  icon: Icon(Icons.margin),
                    hintText: "Enter Your Memory"
                ),
              ),
              TextFormField(
                controller: loc,
                decoration: const InputDecoration(
                    icon: Icon(Icons.location_on),
                    hintText: "Enter the Location"
                ),
              ),
              TextFormField(
                controller: img_name,
                decoration: const InputDecoration(
                    icon: Icon(Icons.image),
                    hintText: "Enter the imageName"
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              image != null
                  ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    //to show image, you type like this.
                    File(image!.path),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                  ),
                ),
              )
                  : Center(
                    child: const Text(
                "No Image",
                style: TextStyle(fontSize: 20),
              ),
                  ),
              const SizedBox(
                height: 50,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: ElevatedButton(
                  onPressed: () async{
                    myAlert();


                  },
                  child: const Text('Upload Photo'),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: ElevatedButton(onPressed: () async{
                  Reference reference=FirebaseStorage.instance.ref();
                  Reference referenceDir=reference.child("images/");

                  String image_name="${img_name.text}.jpg";

                  //create reference for the img to be stored
                  Reference referenceImg=referenceDir.child(image_name);
                  // print(file!.path);
                  await referenceImg.putFile(File(file!.path));

                  //Get the download url

                  img2_url = await referenceImg.getDownloadURL();
                  // print(img2_url);
                  // print(uid1.toString());
                  try {

                    // String uid=_auth.currentUser!.uid;
                    // print(uid1.toString());
                    final firestore = FirebaseFirestore.instance;
                    await firestore.collection("memory").doc(uid1.toString()).collection("message").count().get().then(
                          (res) {
                            post_id=res.count+1;
                            // print(res.count);
                          },
                      onError: (e) => print("Error completing: $e"),
                    );
                    print(post_id.toString());
                    DocumentReference documentReference = firestore.collection("memory").doc(uid1.toString()).collection('message').doc(post_id.toString());

                    // await documentReference.set(userModel(username: name, useremail: email, password: pass,uid: _auth.currentUser!.uid.toString()).toJson());
                    await documentReference.set(memory_model(Discription: dis.text, Location: loc.text, imagename: img_name.text, image_url: img2_url, uid: uid1.toString(),date: date.toString()).toJson()).then((value) {

                    });
                    Navigator.pop(context,MaterialPageRoute(builder: (context) => userMemory(),));
                  }
                  catch(e){
                    // print("hbbshbf");
                    print(e);
                  }
                }, child: Text("Submit")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
