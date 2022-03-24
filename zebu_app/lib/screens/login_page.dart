import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:zebu_app/routeGenerator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
    //     errorText: 'passwords must have at least one special character')
  ]);

  final emailValidator = MultiValidator([
    EmailValidator(errorText: 'Invalid email'),
    RequiredValidator(errorText: "Email is required")
  ]);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 80),
        child: Column(
          children: [
            // login Text
            const Text(
              'Log in',
              style: TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 50),

            // Form goes here
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add TextFormFields and ElevatedButton here.

                  // email field
                  Container(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: TextFormField(
                      // The validator receives the text that the user has entered.
                      decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: emailValidator,
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // password field
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      // The validator receives the text that the user has entered.
                      obscureText: true,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: passwordValidator,
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                  ),
                  SizedBox(height: 50),

                  // submit Button
                  Container(
                    margin: EdgeInsets.only(left: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          logIn();
                        }
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all<Size?>(
                            Size.fromHeight(50)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
                            const EdgeInsets.only(left: 130, right: 130)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 131, 19, 4)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Log in',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future logIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
