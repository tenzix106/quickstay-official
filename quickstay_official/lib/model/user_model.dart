import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  List<PostingModel>? savedPostings;

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
    savedPostings = [];
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

  addSavedPosting(PostingModel posting) async {
    for (var savedPosting in savedPostings!) {
      if (savedPosting.id == posting.id) {
        return;
      }
    }

    savedPostings!.add(posting);

    List<String> savedPostingIDs = [];

    savedPostings!.forEach((savedPosting) {
      savedPostingIDs.add(savedPosting.id!);
    });

    await FirebaseFirestore.instance.collection("users").doc(id).update({
      'savedPostingIDs': savedPostingIDs,
    });

    Get.snackbar("Marked as Saved Posting", "Saved to your Favourite List!");
  }

  removeSavedPosting(PostingModel posting) async {
    for (int i = 0; i < savedPostings!.length; i++) {
      if (savedPostings![i].id == posting.id) {
        savedPostings!.removeAt(i);
        break;
      }
    }

    List<String> savedPostingIDs = [];

    savedPostings!.forEach((savedPosting) {
      savedPostingIDs.add(savedPosting.id!);
    });

    await FirebaseFirestore.instance.collection("users").doc(id).update({
      'savedPostingIDs': savedPostingIDs,
    });

    Get.snackbar(
        "Listing Removed", "Listing removed from your Favourite List!");
  }

  Future<void> addBookingToFirestore(
      BookingModel booking, double totalPrice) async {
    String earningOld = "";

    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .then((dataSnap) {
      earningOld = dataSnap["earnings"].toString();
    });

    Map<String, dynamic> data = {
      'dates': booking.dates,
      'postingID': booking.posting!.id!
    };

    await FirebaseFirestore.instance
        .doc('users/${id}/bookings/${booking.id}')
        .set(data);

    await FirebaseFirestore.instance.collection("users").doc(id).update({
      "earnings": totalPrice + int.parse(earningOld),
    });
    bookings!.add(booking);

    //await addBookingConversation(booking);
  }
}
