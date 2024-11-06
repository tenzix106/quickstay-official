import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickstay_official/global.dart';
import 'package:quickstay_official/model/app_constants.dart';
import 'package:quickstay_official/view/adminScreens/admin_personal_information_screen.dart';
import 'package:quickstay_official/view/guest_home_screen.dart';
import 'package:quickstay_official/view/host_home_screen.dart';
import 'package:quickstay_official/view/login_screen.dart';

class AdminAccountScreen extends StatefulWidget {
  const AdminAccountScreen({super.key});

  @override
  State<AdminAccountScreen> createState() => AdminAccountScreenState();
}

class AdminAccountScreenState extends State<AdminAccountScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Center(
                  child: Column(
                    children: [
                      // Image
                      MaterialButton(
                        onPressed: () {},
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: MediaQuery.of(context).size.width / 4.5,
                          child: CircleAvatar(
                            backgroundImage: AppConstants.currentUser .displayImage,
                            radius: MediaQuery.of(context).size.width / 4.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Name and Email
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppConstants.currentUser .getFullNameOfUser (),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            AppConstants.currentUser .email.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            AppConstants.currentUser.bio.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),

              // Options List
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildOptionTile(
                    title: "Personal Information",
                    icon: Icons.person_2,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminPersonalInformationScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildOptionTile(
                    title: "Log Out",
                    icon: Icons.login_outlined,
                    onTap: () {
                      // Handle log out
                      FirebaseAuth.instance.signOut();
                      Get.offAll(LoginScreen()); // Navigate to guest home screen
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({required String title, required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(76, 215, 208, 0.8),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: MaterialButton(
        height: MediaQuery.of(context).size.height / 9.1,
        onPressed: onTap,
        child: ListTile(
          contentPadding: const EdgeInsets.all(0.0),
          leading: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          trailing: Icon(
            size: 34,
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}