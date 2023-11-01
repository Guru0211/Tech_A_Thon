import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_a_thon/Service/backend.dart';
// import 'package:tech_a_thon/screen/HomePage.dart';
import 'package:tech_a_thon/screen/list_user_memory.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late String data = "";
  bool _isHidden = true;
  var a1 = 0;
  final a = TextEditingController();
  final b = TextEditingController();
  final c = TextEditingController();

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tech-A-Thon",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent[100],
      ),
      body: ListView(children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent[100],
              border: Border.all(strokeAlign: 10),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.fromLTRB(
                width * 0.15, height * 0.25, width * 0.15, height * 0.25),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "SignUp",
                  style: TextStyle(
                    fontSize: width * 0.05,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.03),
                TextFormField(
                  controller: c,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.person), labelText: "Name:"),
                ),
                SizedBox(height: height * 0.03),
                TextFormField(
                  controller: a,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.alternate_email),
                    labelText: "Email:",
                  ),
                ),
                SizedBox(height: height * 0.02),
                TextFormField(
                    controller: b,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.key),
                      labelText: "Password:",
                      suffix: GestureDetector(
                        onTap: _handlePasswordToggle, // Call a function to handle the tap event
                        child: Icon(
                          _isHidden
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  obscureText: _isHidden,
                    onChanged: (value) {
                      int null1 = 0;
                      if (value == "" && a1 == 0) {
                        null1 = 0;
                        a1 = a1 + 1;
                        setState(() {
                          data = "Enter Password";
                        });
                      } else {
                        null1 = 1;
                        setState(() {
                          data = "";
                        });
                      }
                      int len = value.length;
                      int max = 0;
                      if (len < 6 && null1 == 1) {
                        max = 0;
                        a1 = a1 + 1;
                        setState(() {
                          data = "Password length should be greater than 5";
                        });
                      } else {
                        max = 1;
                        setState(() {
                          data = "";
                        });
                      }
                      if (!RegExp("^(?=.{8,32}\$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?:{}|<>]).*")
                              .hasMatch(value) &&
                          max == 1) {
                        a1 = a1 + 1;
                        setState(() {
                          data =
                              "Minimum 1 Upper case,lowercase,Numeric Number,1 Special Character( ! @ # \$ & * ~ )";
                        });
                      }
                      if (a1 == 3) {
                        setState(() {
                          data = "";
                        });
                      }
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width*0.07),
                  child: Text(data,style: const TextStyle(fontSize: 10,color: Colors.red)),
                ),
                SizedBox(height: height * 0.03),
                ElevatedButton(
                    onPressed: () async {
                      final back_in= Provider.of<backend>(context,listen: false);
                      var res = await back_in.sign_up(a.text, b.text, c.text);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(res!),
                      ));
                      if (a1 == 3) {
                        a1 = 0;
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  userMemory(),
                            ));
                      }
                    },
                    child: const Text("Create")),
                SizedBox(height: height * 0.02),
              ],
            ),
          ),
        )
      ]),
    );
  }
  void _handlePasswordToggle() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
