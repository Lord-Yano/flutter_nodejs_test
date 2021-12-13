import 'package:weighttracker_flutter/models/user.dart';
import 'package:weighttracker_flutter/widgets/input.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;
  User user = User();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController passwordConfirmation = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
            child: Container(
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Sign Up",
                  style: TextStyle(color: primaryColor, fontSize: 50),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InputWidget(
                    inputController: firstName,
                    hintText: "First Name",
                    errorText: "Please enter first name",
                    obscure: false,
                    icon: (Icon(Icons.person)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InputWidget(
                    inputController: lastName,
                    hintText: "Last Name",
                    errorText: "Please enter last name",
                    obscure: false,
                    icon: (Icon(Icons.person)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InputWidget(
                    inputController: email,
                    hintText: "Email",
                    errorText: "Please enter email",
                    obscure: false,
                    icon: (Icon(Icons.person)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InputWidget(
                    inputController: password,
                    hintText: "Password",
                    errorText: "Please enter password",
                    obscure: true,
                    icon: (Icon(Icons.person)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InputWidget(
                    inputController: passwordConfirmation,
                    hintText: "Confirm Password",
                    errorText: "Please confirm password",
                    obscure: true,
                    icon: (Icon(Icons.person)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    height: 50,
                    width: 500,
                    child: FlatButton(
                        color: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _signUp();
                          } else {
                            print("not ok");
                          }
                        },
                        child: Text(
                          _isLoading ? 'Proccessing...' : 'Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(65, 20, 0, 0),
                    child: Row(
                      children: [
                        Text(
                          "Already have Account ? ",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            "Login",
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

  void _signUp() {
    setState(() {
      _isLoading = true;
    });
    final data = {
      "firstName": firstName.text.trim(),
      "lastName": lastName.text.trim(),
      'email': email.text.trim(),
      'password': password.text,
      'passwordConfirmation': passwordConfirmation.text
    };
    user.signUp(data).then((value) {
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
