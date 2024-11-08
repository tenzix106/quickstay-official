import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickstay_official/global.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();
  TextEditingController _firstNameTextEditingController = TextEditingController();
  TextEditingController _lastNameTextEditingController = TextEditingController();
  TextEditingController _cityTextEditingController = TextEditingController();
  TextEditingController _countryTextEditingController = TextEditingController();
  TextEditingController _bioTextEditingController = TextEditingController();


  File? imageFileOfUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(76, 215, 208, 100),
          ),
        ),
        title: const Text(
          'Create New Account',
          style: TextStyle(
            color: Colors.white,
          ),
        )
    ),
    body: Container(
      decoration: const BoxDecoration(
            gradient: LinearGradient(
            colors: [
              Color.fromRGBO(76, 215, 208, 100),
              Colors.amber,
            ],
            begin:FractionalOffset(1, 1),
            end: FractionalOffset(0, 0),
            stops: [0,1],
            tileMode: TileMode.clamp,
          )
          ),
      child: ListView(
        children: [

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset(
              "assets/images/signup.png",
              width: 240,
            ),
          ),

          const Text(
            "Tell us about Yourself ",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 221, 102, 28),
            ),
            textAlign: TextAlign.center,
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children:[
                  
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: "Email"),
                      style: const TextStyle(
                        fontSize: 25.0,
                      ),
                      controller: _emailTextEditingController,
                      validator: (text)
                      {
                        if (text!.isEmpty)
                        {
                          return "Please enter a valid email";
                        }
                        return null;
                      }
                    ),
                  ),

                  Padding(
                      padding: const EdgeInsets.only(top: 21.0),
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
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: "First Name"),
                      style: const TextStyle(
                        fontSize: 25.0,
                      ),
                      controller: _firstNameTextEditingController,
                      validator: (text)
                      {
                        if (text!.isEmpty)
                        {
                          return "Please enter your first name";
                        }
                        return null;
                      }
                    ),
                  ),

                  Padding(
                      padding: const EdgeInsets.only(top: 21.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Last Name"
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        controller: _lastNameTextEditingController,
                        validator: (text)
                        {
                          if (text!.isEmpty)
                          {
                            return "Please enter your last name";
                          }
                          return null;
                        }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 21.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "City"
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        controller: _cityTextEditingController,
                        validator: (text)
                        {
                          if (text!.isEmpty)
                          {
                            return "Please enter your city name";
                          }
                          return null;
                        }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 21.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Country"
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        controller: _countryTextEditingController,
                        validator: (text)
                        {
                          if (text!.isEmpty)
                          {
                            return "Please enter your country name";
                          }
                          return null;
                        }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 21.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Bio"
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        controller: _bioTextEditingController,
                        validator: (text)
                        {
                          if (text!.isEmpty)
                          {
                            return "Please enter your profile bio";
                          }
                          return null;
                        }
                      ),
                    ),
                ]
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 38.0),
            child: MaterialButton(
              onPressed: () async
              {
                var imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

                if(imageFile != null)
                {
                  imageFileOfUser = File(imageFile.path);

                  setState(() {
                    imageFileOfUser;
                  });
                }
              },
              child: imageFileOfUser == null 
                ? const Icon(Icons.add_a_photo) 
                : CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 5.0,
                  child: CircleAvatar(
                    backgroundImage: FileImage(imageFileOfUser!),
                    radius: MediaQuery.of(context).size.width / 5.2,
                  ),
                ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 44, right: 40, left:40),
              child: ElevatedButton(
              onPressed: ()
              {
                if(!_formKey.currentState!.validate() || imageFileOfUser == null)
                {
                  Get.snackbar("Field Missing", "Please choose image and fill out the sign up form.");
                  return;
                }
                if(_emailTextEditingController.text.isEmpty && _passwordTextEditingController.text.isEmpty)
                {
                  Get.snackbar("Field Missing", "Please fill out sign up form");
                  return;
                }

                userViewModel.signUp(
                  _emailTextEditingController.text.trim(),
                  _passwordTextEditingController.text.trim(),
                  _firstNameTextEditingController.text.trim(),
                  _lastNameTextEditingController.text.trim(),
                  _cityTextEditingController.text.trim(),
                  _countryTextEditingController.text.trim(),
                  _bioTextEditingController.text.trim(),
                  imageFileOfUser,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "Create Account",
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                color: Colors.white,
                ),
              ),
            ) ,
            ),
            const SizedBox(
              height: 60,
            ),
        ],
      )
      )
    );
  }
}