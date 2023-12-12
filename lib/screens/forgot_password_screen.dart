import 'dart:math';

import 'package:carpool/global/global.dart';
import 'package:carpool/screens/login_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:users/screens/login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final emailTextEditingController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();


  void _submit() async {
    final email = emailTextEditingController.text.trim();
    final userExists = await firebaseAuth.fetchSignInMethodsForEmail(email);

    if (userExists.isEmpty) {
      Fluttertoast.showToast(msg: "Email not found. Please check your email address and try again.");
    } else {
      firebaseAuth.sendPasswordResetEmail(email: email,).then((value) {
        Fluttertoast.showToast(msg: "Email Sent. Please check your email to reset your password.");
      }).catchError((errorMessage) {
          Fluttertoast.showToast(msg: "Error occurred: \n $errorMessage");
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;


    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: ListView (
            padding: EdgeInsets.all(0),
            children: [
              Column(
                children: [
                  Image.asset('assets/unicampus.jpg'),

                  SizedBox(height: 20,),


                  Text(
                    'Forgot Password' ,
                    style: TextStyle(
                      color: darkTheme ? Colors.amber.shade400 : Colors.deepPurpleAccent,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(100)
                                ],
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none
                                      )
                                  ),
                                  prefixIcon: Icon(Icons.email, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text ==null || text.isEmpty) {
                                    return "Email can't be empty";
                                  }
                                  if (EmailValidator.validate(text) == true) {
                                    return null;
                                  }
                                  if (text.length > 99) {
                                    return "Email can\'t be more than 100 characters";
                                  }
                                },
                                onChanged: (text) => setState(() {
                                  emailTextEditingController.text = text;
                                }),
                              ),

                              SizedBox(height: 30,),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.deepPurpleAccent,
                                    foregroundColor: darkTheme ? Colors.black : Colors.white,
                                    elevation: 0,
                                    minimumSize: Size(20, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    )
                                ),
                                onPressed:  () {
                                  _submit();
                                },
                                child: Text(
                                    'Send Reset Password link',
                                    style: TextStyle(
                                      fontSize: 15,
                                    )
                                ),
                              ),

                              SizedBox(height:20,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "Already have an account?",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                      )
                                  ),

                                  SizedBox(width: 5,),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: darkTheme ? Colors.amber.shade400 : Colors.deepPurpleAccent,
                                      ),
                                    ),
                                  )
                                ],
                              )


                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}
