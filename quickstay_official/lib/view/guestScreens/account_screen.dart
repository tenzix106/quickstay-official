import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickstay_official/global.dart';
import 'package:quickstay_official/model/app_constants.dart';
import 'package:quickstay_official/model/user_model.dart';
import 'package:quickstay_official/view/guest_home_screen.dart';
import 'package:quickstay_official/view/host_home_screen.dart';
import 'package:quickstay_official/view/login_screen.dart';
import 'package:quickstay_official/view/personal_information_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  String _hostingTitle = 'Show my Host Dashboard';

  @override
  void initState() {
    super.initState();
    _updateHostingTitle();
  }

  void _updateHostingTitle() {
    if (AppConstants.currentUser.isHost!) {
      _hostingTitle = AppConstants.currentUser.isCurrentlyHosting!
          ? 'Show my Guest Dashboard'
          : 'Show my Host Dashboard';
    } else {
      _hostingTitle = "Become a host";
    }
  }

  void modifyHostingMode() async {
    if (AppConstants.currentUser.isHost!) {
      AppConstants.currentUser.isCurrentlyHosting =
          !AppConstants.currentUser.isCurrentlyHosting!;
      Get.to(AppConstants.currentUser.isCurrentlyHosting!
          ? HostHomeScreen()
          : GuestHomeScreen());
    } else {
      await userViewModel.becomeHost(FirebaseAuth.instance.currentUser!.uid);
      AppConstants.currentUser.isCurrentlyHosting = true;
      Get.to(HostHomeScreen());
    }
  }

  void _logout() async {
    //AppConstants.currentUser = UserModel();
    await FirebaseAuth.instance.signOut();
    Get.offAll(LoginScreen()); // Navigate to guest home screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 50, 20, 0),
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
                      // Profile Image
                      MaterialButton(
                        onPressed: () {},
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: MediaQuery.of(context).size.width / 4.5,
                          child: CircleAvatar(
                            backgroundImage:
                                AppConstants.currentUser.displayImage,
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
                            AppConstants.currentUser.getFullNameOfUser(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            AppConstants.currentUser.email.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
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
                        MaterialPageRoute(
                            builder: (context) =>
                                const PersonalInformatioScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildOptionTile(
                    title: _hostingTitle,
                    icon: Icons.hotel_outlined,
                    onTap: () {
                      modifyHostingMode();
                      setState(() {
                        _updateHostingTitle();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildOptionTile(
                    title: "Log Out",
                    icon: Icons.login_outlined,
                    onTap: _logout,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
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
