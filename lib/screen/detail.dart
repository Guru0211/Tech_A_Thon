import 'package:flutter/material.dart';

class detail extends StatefulWidget {
  String des;
  String img_url;
  String Location;
  String Date;
  detail({
    required this.des,
    required this.img_url,
    required this.Location,
    required this.Date
});

  @override
  State<detail> createState() => _detailState(des: des,img_url: img_url,Location: Location,Date: Date);
}

class _detailState extends State<detail> {
  String des;
  String img_url;
  String Location;
  String Date;
  _detailState({
    required this.des,
    required this.img_url,
    required this.Location,
    required this.Date
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(des), backgroundColor:Colors.deepPurpleAccent[100],),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.network(img_url),
              ),
              Center(child: Text("Location:"+Location,style: TextStyle(
                fontSize: 30
              ),)),
              Center(child: Text("Date:"+Date,style: TextStyle(
                  fontSize: 20
              ))),
            ],
          ),
        ),
      ),
    );
  }
}

