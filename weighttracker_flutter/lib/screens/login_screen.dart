// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:weighttracker_flutter/models/user.dart';
import 'package:weighttracker_flutter/screens/signup_screen.dart';
import 'package:weighttracker_flutter/widgets/input.dart';
import 'package:weighttracker_flutter/widgets/toast.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool fatchingUser = true;
  User user = User();
  final _formKey = GlobalKey<FormState>();

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  void initState() {
    super.initState();
    user.getUser().then((value) {
      setState(() {
        fatchingUser = false;
      });
      if (value == true) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: fatchingUser
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                alignment: Alignment.center,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 150,
                      ),
                      const Text(
                        "Login",
                        style: TextStyle(color: primaryColor, fontSize: 50),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InputWidget(
                          inputController: email,
                          hintText: "Email",
                          errorText: "Please enter email",
                          obscure: false,
                          icon: (const Icon(Icons.person)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InputWidget(
                          inputController: password,
                          hintText: "Password",
                          errorText: "Please enter password",
                          obscure: true,
                          icon: (const Icon(Icons.person)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          height: 50,
                          width: 500,
                          child: FlatButton(
                              color: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _login();
                                } else {
                                  toast("Please enter fields", "error");
                                }
                              },
                              child: Text(
                                _isLoading ? 'Proccessing...' : 'Login',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(90, 20, 0, 0),
                          child: Row(
                            children: [
                              const Text(
                                "No Account ? ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              SignUpScreen()));
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: secondaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              )));
  }

  void _login() {
    setState(() {
      _isLoading = true;
    });
    final data = {'email': email.text.trim(), 'password': password.text};
    user.login(data).then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value == true) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false);
      }
    });
  }
}
