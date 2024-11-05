import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickstay_official/model/posting_model.dart';
import 'package:quickstay_official/view/adminScreens/verify_postings_screen.dart';
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
    VerifyPostingsScreen(),
    // UsersScreen(),
    // PostingsScreen(),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUnverifiedPostings();
  }

  Future<void> fetchUnverifiedPostings() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('postings')
        .where('verified', isEqualTo: false)
        .get();

    setState(() {
      unverifiedPostings = snapshot.docs.map((doc) {
        PostingModel posting = PostingModel(id: doc.id);
        posting.getPostingInfoFromSnapshot(doc);
        return posting;
      }).toList();
    });

    Get.snackbar("Posting Verified", "The posting has been verified!");
  }

  Future<void> verifyPosting(PostingModel posting) async {
    await FirebaseFirestore.instance
        .collection('postings')
        .doc(posting.id)
        .update({'verified': true});

    setState(() {
      unverifiedPostings.remove(posting);
    });

    Get.snackbar(
        "Posting Verified", "The posting has been verified successfully.");
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
            customNavigationBarItem(0, Icons.search, screenTitles[0]),
            customNavigationBarItem(1, Icons.favorite_border, screenTitles[1]),
            customNavigationBarItem(2, Icons.hotel, screenTitles[2]),
            customNavigationBarItem(3, Icons.message, screenTitles[3]),
          ]
      ),
    );
  }
}
