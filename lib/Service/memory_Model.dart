class memory_model{
  final String Discription;
  final String Location;
  final String imagename;
  final String image_url;
  final  String uid;
  final String date;

  const memory_model({
    required this.Discription,
    required this.Location,
    required this.imagename,
    required this.image_url,
    required this.uid,
    required this.date,
  });


  toJson(){
    return{
      "Discription":Discription,
      "Location":Location,
      "imagename":imagename,
      "image_url":image_url,
      "Uid":uid,
      "date":date
    };
  }

}



