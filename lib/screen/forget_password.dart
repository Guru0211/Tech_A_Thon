import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_a_thon/Service/backend.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final a=TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          title: Text("Tech-A-Thon",
              style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black54,fontSize: w * 0.04,)),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent[100]),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.1, vertical: h * 0.1),
        children: [
          SizedBox(
            height: h * 0.08,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text("Login",
                style: TextStyle(
                  fontSize: w * 0.03,
                  color: Colors.deepPurpleAccent[100],
                  fontWeight: FontWeight.bold,
                )),
          ),
          TextFormField(
            controller: a,
            decoration: const InputDecoration(
                icon: Icon(Icons.alternate_email), labelText: "Email:"),
          ),
          SizedBox(
            height: h * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.2),
            child: ElevatedButton(onPressed: () async{
              final back_in= Provider.of<backend>(context,listen:false);
              var res;
              try{
                res = await back_in.reset_password(a.text);

              }
              catch(e){

              }
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(res!),
              ));
            }, child: const Text("Reset")),
          ),
        ],
      ),
    );
  }
}
