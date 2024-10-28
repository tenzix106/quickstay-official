import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:quickstay_official/model/app_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserViewModel
{
  signUp(email, password, firstName, lastName, city, country, bio, imageFileOfUser) async
  {
    Get.snackbar("Please wait...", "we are creating your account.");
    try
    {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(

        email: email,
        password: password,
      ).then((result)
      async {
        String currentUserID = result.user!.uid;

        AppConstants.currentUser.id = currentUserID;
        AppConstants.currentUser.firstName = firstName;
        AppConstants.currentUser.lastName = lastName;
        AppConstants.currentUser.city = city;
        AppConstants.currentUser.country = country;
        AppConstants.currentUser.bio = bio;
        AppConstants.currentUser.email = email;
        AppConstants.currentUser.password = password;

        await saveUserToFirebase(bio, city, country, email, firstName, lastName, currentUserID)
        .whenComplete(()
        {
          addImageToFirebaseStorage(imageFileOfUser, currentUserID);
        });
        Get.snackbar("Congratulations!", "Your account has been created.");
      });
    }
    catch(e)
    {
      Get.snackbar("Error: ", e.toString());
    }
  }


  Future<void> saveUserToFirebase(bio, city, country, email, firstName, lastName, id) async
  {
    Map<String, dynamic> dataMap = 
    {
      "bio": bio,
      "city": city,
      "country": country,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "isHost": false,
      "myPostingIDs": [],
      "savedPostingIDs": [],
      "earnings": 0,
    };

    await FirebaseFirestore.instance.collection("users").doc(id).set(dataMap);
  }
  addImageToFirebaseStorage(File imageFileOfUser, currentUserID) async
  {
    Reference referenceStorage = FirebaseStorage.instance.ref()
      .child("userImages")
      .child(currentUserID)
      .child(currentUserID + ".png");
    await referenceStorage.putFile(imageFileOfUser).whenComplete((){});

    AppConstants.currentUser.displayImage = MemoryImage(imageFileOfUser.readAsBytesSync());
  }


  login(email, password) async
  {
    try
    {
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, 
        password: password,
      ).then((result)
      {
        String currentUserID = result.user!.uid;
        AppConstants.currentUser.id = currentUserID;
      });
    }
    catch(e)
    {
      Get.snackbar("Error: ", e.toString());
    }
  }

  getUserInfoFromFirestore(userID) async
  {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("users").doc(userID).get();
  }
}