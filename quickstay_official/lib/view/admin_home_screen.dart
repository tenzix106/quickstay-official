import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickstay_official/model/posting_model.dart';
import 'package:quickstay_official/view/adminScreens/posting_verification_screen.dart';
import 'package:quickstay_official/view/adminScreens/users_screen.dart';
import 'package:quickstay_official/view/adminScreens/verify_postings_screen.dart';
import 'package:quickstay_official/view/adminScreens/all_postings_screen.dart';
import 'package:quickstay_official/view/admin_account_screen.dart';
import 'package:quickstay_official/view/guestScreens/account_screen.dart';
import 'package:quickstay_official/widgets/posting_list_tile_ui.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<PostingModel> unverifiedPostings = [];

  int selectedIndex = 0;
  final List<String> screenTitles = 
  [
    'Verify',
    'Users',
    'Postings',
    'Profile',
  ];

  final List<Widget> screens = [
    PostingVerificationScreen(),
    UsersScreen(),
    AllPostingsScreen(),
    AdminAccountScreen(),
  ];

  BottomNavigationBarItem customNavigationBarItem(int index, IconData iconData, String title)
  {
    return BottomNavigationBarItem(
      icon: Icon(
        iconData,
        color: Colors.black,
      ),
      activeIcon: Icon(
        iconData,
        color: Colors.deepPurple,
      ),
      label: title,
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
            color: Color.fromRGBO(76, 215, 208, 100),
          ),
        ),
          title: Text(
            screenTitles[selectedIndex],
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
      
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i)
        {
          setState(() {
            selectedIndex = i;
          });
        },
          currentIndex: selectedIndex,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>
          [
            customNavigationBarItem(0, Icons.verified_outlined, screenTitles[0]),
            customNavigationBarItem(1, Icons.supervised_user_circle_outlined, screenTitles[1]),
            customNavigationBarItem(2, Icons.list, screenTitles[2]),
            customNavigationBarItem(3, Icons.person_outlined, screenTitles[3]),
          ]
      ),
    );
  }
}
