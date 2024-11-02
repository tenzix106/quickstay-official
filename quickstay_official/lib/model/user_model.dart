import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickstay_official/global.dart';
import 'package:quickstay_official/model/booking_model.dart';
import 'package:quickstay_official/model/contact_model.dart';
import 'package:quickstay_official/model/posting_model.dart';
import 'package:quickstay_official/model/review_model.dart';

class UserModel extends ContactModel {
  String? email;
  String? password;
  String? bio;
  String? city;
  String? country;
  bool? isHost;
  bool? isCurrentlyHosting;
  DocumentSnapshot? snapshot;

  List<BookingModel>? bookings;
  List<ReviewModel>? reviews;

  List<PostingModel>? myPostings;

  UserModel({
    String id = "",
    String firstName = "",
    String lastName = "",
    MemoryImage? displayImage,
    this.email = "",
    this.bio = "",
    this.city = "",
    this.country = "",
  }) : super(
            id: id,
            firstName: firstName,
            lastName: lastName,
            displayImage: displayImage) {
    isHost = false;
    isCurrentlyHosting = false;

    bookings = [];
    reviews = [];
    myPostings = [];
  }

  Future<void> saveUserToFirebase() async {
    Map<String, dynamic> dataMap = {
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
  }

  addPostingToMyPostings(PostingModel posting) async {
    myPostings!.add(posting);

    List<String> myPostingIDsList = [];

    myPostings!.forEach((element) {
      myPostingIDsList.add(element.id!);
    });

    await FirebaseFirestore.instance.collection("users").doc(id).update({
      'myPostingIDs': myPostingIDsList,
    });
  }

  getMyPostingFromFirestore() async {
    List<String> myPostingIDs =
        List<String>.from(snapshot!["myPostingIDs"]) ?? [];

    for (String postingID in myPostingIDs) {
      PostingModel posting = PostingModel(id: postingID);

      await posting.getPostingInfoFromFirestore();
      await posting.getAllImagesFromStorage();

      myPostings!.add(posting);
    }
  }
}
