import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_a_thon/Service/backend.dart';
// import 'package:tech_a_thon/screen/HomePage.dart';
import 'package:tech_a_thon/screen/SignUp.dart';
import 'package:tech_a_thon/screen/forget_password.dart';
import 'package:tech_a_thon/screen/home.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isHidden = true;
  final a = TextEditingController();
  final b = TextEditingController();
  @override
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
                  "Login",
                  style: TextStyle(
                    fontSize: width * 0.05,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
                    suffix: GestureDetector(
                      onTap:
                          _handlePasswordToggle, // Call a function to handle the tap event
                      child: Icon(
                        _isHidden ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    icon: Icon(Icons.key),
                    labelText: "Password:",
                  ),
                  obscureText: _isHidden,
                ),
                SizedBox(height: height * 0.009),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.19),
                  child: TextButton(
                    style: const ButtonStyle(
                        overlayColor:
                            MaterialStatePropertyAll(Colors.transparent)),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPassword(),
                        ),
                      );
                    },
                    child: const Text("Forget your password?",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: height * 0.01),
                ElevatedButton(
                  onPressed: () async {
                    final back_in= Provider.of<backend>(context,listen: false);
                    var res = await back_in.sign_in(a.text, b.text);
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //   content: Text(res!),
                    // ));
                    if (res == "Login Successfully") {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => home_Demo(email: a.text),
                        ),
                      );
                    }
                  },
                  child: const Text("Login"),
                ),
                // Text("Or"),
                // ElevatedButton(
                //     onPressed: () {
                //       final back_in= Provider.of<backend>(context,listen: false);
                //       var gsi=back_in.google_login();
                //     },
                //     style: ButtonStyle(
                //         backgroundColor: MaterialStatePropertyAll(
                //       Colors.deepPurpleAccent[100],
                //     ),
                //       overlayColor:const MaterialStatePropertyAll(Colors.transparent),
                //     elevation: const MaterialStatePropertyAll(0),
                //     ),
                //     child: Image.asset(
                //       "Assets/google.png",
                //       width: 30,
                //       height: 30,
                //     )),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have account?"),
                    TextButton(
                      style: const ButtonStyle(
                          overlayColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Signup(),
                          ),
                        );
                      },
                      child: const Text("SignUp",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void _handlePasswordToggle() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
