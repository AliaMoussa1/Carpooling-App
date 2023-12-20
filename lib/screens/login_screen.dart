import 'dart:convert';

import 'package:carpool/screens/profile_screen.dart';
import 'package:carpool/screens/signup_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carpool/screens/forgot_password_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../global/db_helper.dart';
import '../global/global.dart';
import '../models/user_model.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailTextEditingController = new TextEditingController();
  final passwordTextEditingController = new TextEditingController();

  bool _passwordVisible = false;

  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      await firebaseAuth.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim()
      ).then((auth) async {
        currentUser = auth.user;

        // Update local database with user data
        await updateLocalDatabase();
        await Future.delayed(Duration(seconds: 3));
        print("Local database update complete.");

        await Fluttertoast.showToast(msg: "Successfully logged in");
        Navigator.push(context, MaterialPageRoute(builder: (c) => ProfileScreen()));
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: "Error occurred: \n $errorMessage");
      });
    }
    else{
      Fluttertoast.showToast(msg: "Not all fields are valid");
    }
  }

  static Future<void> updateLocalDatabase() async {

    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentUser!.uid);

    userRef.once().then((snap) async {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);

        // Convert UserModel to a map
        Map<String, dynamic> userMap = {
          "id": userModelCurrentInfo!.id,
          "name": userModelCurrentInfo!.name,
          "email": userModelCurrentInfo!.email,
          "phone": userModelCurrentInfo!.phone,
        };

        String currentUserId = currentUser!.uid;
        List<Map> existingUser = await mydb.read('''SELECT * FROM Users WHERE ID = '$currentUserId' ''');

        print('Existing User is: ${existingUser}');

        if (existingUser.isEmpty) {
          // User doesn't exist, insert a new record
          await mydb.write('''INSERT INTO Users
          (ID, Name, Email, Phone) VALUES 
          ('${userModelCurrentInfo!.id}', '${userModelCurrentInfo!.name}', 
          '${userModelCurrentInfo!.email}', '${userModelCurrentInfo!.phone}')''');

          print("New user inserted successfully.");
        }

      }
    });
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
                    'Login' ,
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

                              SizedBox(height: 10,),


                              TextFormField(
                                obscureText: !_passwordVisible,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
                                decoration: InputDecoration(
                                    hintText: "Password",
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
                                    prefixIcon: Icon(Icons.lock_rounded, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                        color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    )
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text ==null || text.isEmpty) {
                                    return "Password can't be empty";
                                  }
                                  if (text.length < 8) {
                                    return "Please enter valid password";
                                  }
                                  if (text.length > 49) {
                                    return "Password can\'t be more than 50 characters";
                                  }
                                  return null;
                                },
                                onChanged: (text) => setState(() {
                                  passwordTextEditingController.text = text;
                                }),
                              ),

                              SizedBox(height: 10,),


                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.deepPurpleAccent,
                                    foregroundColor: darkTheme ? Colors.black : Colors.white,
                                    elevation: 0,
                                    minimumSize: Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    )
                                ),
                                onPressed:  () {
                                  _login();
                                },
                                child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 25,
                                    )
                                ),
                              ),

                              SizedBox(height:20,),


                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (c) => ForgotPasswordScreen()));
                                },
                                child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: darkTheme ? Colors.amber.shade400 : Colors.deepPurpleAccent,
                                    )
                                ),
                              ),


                              SizedBox(height:20,),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "Don't have an account?",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                      )
                                  ),

                                  SizedBox(width: 5,),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (c) => SignupScreen()));
                                    },
                                    child: Text(
                                      "Register",
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
