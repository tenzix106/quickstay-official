import 'package:flutter/material.dart';

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
            color: Color.fromRGBO(248, 234, 140, 100),
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
            "Tell us about you: ",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 221, 102, 28),
            ),
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
          )

        ],
      )
      )
    );
  }
}