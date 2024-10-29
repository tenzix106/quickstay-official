import 'package:flutter/material.dart';
import 'package:quickstay_official/view/guestScreens/account_screen.dart';
import 'package:quickstay_official/view/guestScreens/explore_screen.dart';
import 'package:quickstay_official/view/guestScreens/inbox_screen.dart';
import 'package:quickstay_official/view/guestScreens/saved_listings_screen.dart';
import 'package:quickstay_official/view/guestScreens/trips_screen.dart';
import 'package:quickstay_official/view/hostScreens/bookings_screen.dart';
import 'package:quickstay_official/view/hostScreens/my_postings_screen.dart';

class HostHomeScreen extends StatefulWidget {
  const HostHomeScreen({super.key});

  @override
  State<HostHomeScreen> createState() => _HostHomeScreenState();
}

class _HostHomeScreenState extends State<HostHomeScreen> {

  int selectedIndex = 0;
  final List<String> screenTitles = 
  [
    'Bookings',
    'My Postings',
    'Inbox',
    'Profile',
  ];

  final List<Widget> screens = [
    BookingsScreen(),
    MyPostingsScreen(),
    InboxScreen(),
    AccountScreen(),
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
  @override
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
            customNavigationBarItem(0, Icons.calendar_today, screenTitles[0]),
            customNavigationBarItem(1, Icons.home, screenTitles[1]),
            customNavigationBarItem(2, Icons.message, screenTitles[2]),
            customNavigationBarItem(3, Icons.person_outline, screenTitles[3]),
          ]
      ),
    );
  }
}