import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> pick_image(String? email) async{
  //1.pick image
  ImagePicker imagePicker=ImagePicker();
  XFile file=await imagePicker.pickImage(source: ImageSource.gallery) as XFile;
  print(file.path);

  //2.upload img in firebase

  //Get reference to storage r0ot
  Reference reference=FirebaseStorage.instance.ref();
  Reference referenceDir=reference.child("images/");

  String image_name=email!+".jpg";

  //create reference for the img to be stored
  Reference referenceImg=referenceDir.child(image_name);

  try {
   await referenceImg.putFile(File(file.path));

    //Get the download url

    String img_Url = await referenceImg.getDownloadURL();
    print(img_Url);
    return img_Url;
  }
  catch(e){
    print(e);
    return "Upload Failed";
  }
  //store file

}
