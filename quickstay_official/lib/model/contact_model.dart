import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quickstay_official/model/user_model.dart';

class ContactModel {
  String? id;
  String? firstName;
  String? lastName;
  String? fullName;
  String? city;
  String? country;
  String? location;
  MemoryImage? displayImage;

  ContactModel({
    this.id = "",
    this.firstName = "",
    this.lastName = "",
    this.displayImage,
  });

  String getFullNameOfUser() {
    return fullName = firstName! + " " + lastName!;
  }

  String getLocationOfUser()
  {
    return location = city! + ", " + country!;
  }

  UserModel createUserFromContact() {
    return UserModel(
      id: id!,
      firstName: firstName!,
      lastName: lastName!,
      city: city!,
      country: country!,
      displayImage: displayImage!,
    );
  }

  getContactInfoFromFirestore() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    firstName = snapshot['firstName'] ?? "";
    lastName = snapshot['lastName'] ?? "";
  }

  getImageFromStorage() async {
    if (displayImage != null) {
      return displayImage;
    }

    final imageData = await FirebaseStorage.instance
        .ref()
        .child("userImages")
        .child(id!)
        .child("$id.png")
        .getData(2048 * 2048);

    displayImage = MemoryImage(imageData!);

    return displayImage;
  }
}
