import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickstay_official/global.dart';
import 'package:quickstay_official/view/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(76, 215, 208, 100),
              Colors.amber,
            ],
            begin:FractionalOffset(0, 0),
            end: FractionalOffset(1, 1),
            stops: [0,1],
            tileMode: TileMode.clamp,
          )
        ),
        child: ListView(
          children: [
            Image.asset(
              "assets/images/quickstay_logo.png"
            ),
            const Text(
              "Welcome to QuickStay!",
              
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 26.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Email"
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        controller: _emailTextEditingController,
                        validator: (valueEmail)
                        {
                          if(!valueEmail!.contains("@")) {
                            return "Please enter a valid email address.";
                          }
                          return null;
                        },
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 26.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Password"
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        controller: _passwordTextEditingController,
                        obscureText: true,
                        validator: (valuePassword)
                        {
                          if(valuePassword!.length < 5) {
                            return "Password must be 6 or more characters.";
                          }
                          return null;
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 26.0),
                      child: ElevatedButton(
                        onPressed: () async
                          {
                            if(_formKey.currentState!.validate()) 
                            {
                              userViewModel.login(
                                _emailTextEditingController.text.trim(),
                                _passwordTextEditingController.text.trim());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(1, 254, 225, 0.612),
                            padding: const EdgeInsets.symmetric(horizontal: 60)
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                              color: Colors.white,
                          ),
                        ),
                      ) ,
                    ),
                    TextButton(
                      onPressed: ()
                      {
                        Get.to(SignUpScreen());
                      },
                      child: Text(
                        "Don't have an account? Sign up here!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              )
            ),
            const SizedBox(
              height: 60,
            ),
          ],
      ))
    );
  }
}

