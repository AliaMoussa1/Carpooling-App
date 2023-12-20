import 'package:carpool/screens/forgot_password_screen.dart';
import 'package:carpool/screens/login_screen.dart';
import 'package:carpool/screens/profile_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carpool/global/global.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameTextEditingController = new TextEditingController();
  final emailTextEditingController = new TextEditingController();
  final phoneTextEditingController = new TextEditingController();
  final passwordTextEditingController = new TextEditingController();

  bool _passwordVisible = false;

  // GlobalKey
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      String email = emailTextEditingController.text.trim();
      String domain = email.split('@')[1]; // Extract the domain part from the email

      if (domain == 'eng.asu.edu.eg') {
        // Proceed with creating the user in Firebase
        await firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: passwordTextEditingController.text.trim()
        ).then((auth) async {
          currentUser = auth.user;

          if (currentUser != null) {
            Map<String, dynamic> userMap = {
              "id": currentUser!.uid,
              "name": nameTextEditingController.text.trim(),
              "email": emailTextEditingController.text.trim(),
              "phone": phoneTextEditingController.text.trim(),
            };

            // Save user data to sqflite
            // await DBHelper.instance.insertUser(userMap);

            // Save user data to Firebase Realtime Database
            DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");
            userRef.child(currentUser!.uid).set(userMap);


          }
          Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
        }).catchError((errorMessage) {
          Fluttertoast.showToast(msg: "Error occurred: \n $errorMessage");
        });
      } else {
        Fluttertoast.showToast(msg: "Invalid email domain. Only ASU FoE students are allowed.");
      }
    } else {
      Fluttertoast.showToast(msg: "Not all fields are valid");
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
                    'Sign Up' ,
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
                                  LengthLimitingTextInputFormatter(50)
                                ],
                                decoration: InputDecoration(
                                  hintText: "Name",
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
                                  prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text ==null || text.isEmpty) {
                                    return "Name can't be empty";
                                  }
                                  if (text.length < 2) {
                                    return "Please enter valid name";
                                  }
                                  if (text.length > 50) {
                                    return "Name can\'t be more than 50 characters";
                                  }
                                },
                                onChanged: (text) => setState(() {
                                  nameTextEditingController.text = text;
                                }),
                              ),

                              SizedBox(height: 10,),


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
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(11)
                                ],
                                decoration: InputDecoration(
                                  hintText: "Phone",
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
                                  prefixIcon: Icon(Icons.phone_android_rounded, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text ==null || text.isEmpty) {
                                    return "Phone Number can't be empty";
                                  }
                                  if (text.length > 11 || text.length < 11 || text.substring(0,2) != "01") {
                                    return "Please enter valid Egyptian Phone Number";
                                  }
                                },
                                onChanged: (text) => setState(() {
                                  phoneTextEditingController.text = text;
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


                              SizedBox(height: 40,),


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
                                  _submit();
                                  // if (emailTextEditingController.text.endsWith("@eng.asu.edu.eg" == false)) {
                                  //   return "Only Faculty of Engineering, Ain Shams University Students can sign up";
                                  // }
                                },
                                child: Text(
                                    'Sign Up',
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
                                      "Have an account?",
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
                                      "Sign In",
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
