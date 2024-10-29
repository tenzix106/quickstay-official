import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickstay_official/global.dart';
import 'package:quickstay_official/model/app_constants.dart';
import 'package:quickstay_official/view/guest_home_screen.dart';
import 'package:quickstay_official/view/host_home_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen>  {

  String _hostingTitle = 'Show my Host Dashboard';

  modifyHostingMode() async
  {

    String _hostingTitle = 'Show my Host Dashboard';


    if(AppConstants.currentUser.isHost!)
    {
      if(AppConstants.currentUser.isCurrentlyHosting!)
      {
        AppConstants.currentUser.isCurrentlyHosting = false;

        Get.to(GuestHomeScreen());
      }
      else
      {
        AppConstants.currentUser.isCurrentlyHosting = true;

        Get.to(HostHomeScreen());
      }
    }
    else
    {
      await userViewModel.becomeHost(FirebaseAuth.instance.currentUser!.uid);
    }
  }
  
  @override
  void initState() {
    super.initState();
    
    if(AppConstants.currentUser.isHost!)
    {
      if(AppConstants.currentUser.isCurrentlyHosting!)
      {
        _hostingTitle = 'Show my Guest Dashboard';
      }
      else
      {
        _hostingTitle = 'Show my Host Dashboard';
      }
    }
    else
    {
      _hostingTitle = "Become a host";
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Padding(
        padding: const EdgeInsets.fromLTRB(25, 50, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            //user info
            Padding(
              padding: const EdgeInsets.only(bottom:30),
              child: Center(
                child: Column(
                  children: [
                    //image
                    MaterialButton(
                      onPressed: (){},
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: MediaQuery.of(context).size.width/4.5,
                        child: CircleAvatar(
                          backgroundImage: AppConstants.currentUser.displayImage,
                          radius: MediaQuery.of(context).size.width / 4.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    //name and email
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppConstants.currentUser.getFullNameOfUser(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        Text(
                          AppConstants.currentUser.email.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),


                      ],
                    )

                  ],
                ),
              ),
            ),

            ListView(
              shrinkWrap: true,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(76, 215, 208, 100),
                  ),
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height / 9.1,
                    onPressed: ()
                    {
                      
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      leading: Text(
                        "Personal Information",
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: Icon(
                        size: 34,
                        Icons.person_2)
                    ),
                  ),
                ),

                const SizedBox(height: 10,),

                //Change Hosting button
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(76, 215, 208, 100),
                  ),
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height / 9.1,
                    onPressed: ()
                    {
                      modifyHostingMode();

                      setState(() {
                        
                      });
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      leading: Text(
                        _hostingTitle,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: Icon(
                        size: 34,
                        Icons.hotel_outlined)
                    ),
                  ),
                ),
              
                const SizedBox(height: 10,),

                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(76, 215, 208, 100),
                  ),
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height / 9.1,
                    onPressed: ()
                    {
                      
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      leading: Text(
                        "Log Out",
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: Icon(
                        size: 34,
                        Icons.login_outlined,
                        )
                    ),
                  ),
                ),
              
                const SizedBox(height: 10,),
              
              ],
            )
          ],
        )
      ),
    );
  }
}