import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickstay_official/global.dart';
import 'package:quickstay_official/model/app_constants.dart';
import 'package:quickstay_official/model/booking_model.dart';
import 'package:quickstay_official/model/contact_model.dart';
import 'package:quickstay_official/model/review_model.dart';

class PostingModel {
  String? id;
  String? name;
  String? type;
  double? price;
  String? description;
  String? address;
  String? city;
  String? country;
  double? rating;

  ContactModel? host;

  List<String>? imageNames;
  List<MemoryImage>? displayImages;
  List<String>? amenities;

  Map<String, int>? beds;
  Map<String, int>? bathrooms;

  List<BookingModel>? bookings;
  List<ReviewModel>? reviews;

  PostingModel(
      {this.id = "",
      this.name = "",
      this.type = "",
      this.price = 0,
      this.description = "",
      this.address = "",
      this.city = "",
      this.country = "",
      this.host}) {
    displayImages = [];
    amenities = [];

    beds = {};
    bathrooms = {};
    rating = 0;

    bookings = [];
    reviews = [];
  }

  setImagesName() {
    imageNames = [];
    for (int i = 0; i < displayImages!.length; i++) {
      imageNames!.add("image${i}.png");
    }
  }

  getPostingInfoFromFirestore() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('postings').doc(id).get();

    getPostingInfoFromSnapshot(snapshot);
  }

  getPostingInfoFromSnapshot(DocumentSnapshot snapshot) {
    address = snapshot.data().toString().contains('address') ? snapshot.get('address') : "";

    amenities = snapshot.data().toString().contains('amenities')
        ? List<String>.from(snapshot.get('amenities'))
        : [];

    bathrooms = snapshot.data().toString().contains('bathrooms')
        ? Map<String, int>.from(snapshot.get('bathrooms'))
        : {};

    beds = snapshot.data().toString().contains('beds')
        ? Map<String, int>.from(snapshot.get('beds'))
        : {};

    city = snapshot.data().toString().contains('city') ? snapshot.get('city') : "";
    country = snapshot.data().toString().contains('country') ? snapshot.get('country') : "";
    description = snapshot.data().toString().contains('description') ? snapshot.get('description') : "";

    String hostID = snapshot.data().toString().contains('hostId') ? snapshot.get('hostId') : "";
    host = ContactModel(id: hostID);

    imageNames = snapshot.data().toString().contains('imageNames')
        ? List<String>.from(snapshot.get('imageNames'))
        : [];

    name = snapshot.data().toString().contains('name') ? snapshot.get('name') : "";
    price = snapshot.data().toString().contains('price') ? snapshot.get('price').toDouble() : 0.0;
    rating = snapshot.data().toString().contains('rating') ? snapshot.get('rating').toDouble() : 2.5;
    type = snapshot.data().toString().contains('type') ? snapshot.get('type') : "";
  }


  getAllImagesFromStorage() async {
    displayImages = [];

    for (int i = 0; i < imageNames!.length; i++) {
      final imageData = await FirebaseStorage.instance
          .ref()
          .child("postingImages")
          .child(id!)
          .child(imageNames![i])
          .getData(1024 * 1024);

      displayImages!.add(MemoryImage(imageData!));
    }
    return displayImages;
  }

  getFirstImageFromStorage() async {
    // Return the first display image if it's already loaded
    if (displayImages!.isNotEmpty) {
      return displayImages!.first;
    }

    try {
      // Attempt to retrieve the image data from Firebase Storage
      final imageData = await FirebaseStorage.instance
          .ref()
          .child("postingImages")
          .child(id!)
          .child(imageNames!.first)
          .getData(1024 * 1024);

      // Add the image data to displayImages if retrieval is successful
      displayImages!.add(MemoryImage(imageData!));

      return displayImages!.first;
    } catch (e) {
      if (e is FirebaseException && e.code == 'object-not-found') {
        // Handle the case where the image does not exist
        print('Image not found in Firebase Storage for id: $id');
        return null; // or a placeholder image if preferred
      } else {
        // Re-throw other exceptions
        rethrow;
      }
    }
  }


  getAmenitiesString() {
    if (amenities!.isEmpty) {
      return "";
    }

    String amenitiesString = amenities.toString();

    return amenitiesString.substring(1, amenitiesString.length - 1);
  }

  double getCurrentRating() {
    if (reviews!.length == 0) {
      return 4;
    }

    double rating = 0;

    reviews!.forEach((review) {
      rating += review.rating!;
    });

    rating /= reviews!.length;

    return rating;
  }

  getHostFromFirestore() async {
    await host!.getContactInfoFromFirestore();
    await host!.getImageFromStorage();
  }

  int getGuestsNumber() {
    int? numGuests = 0;
    numGuests = numGuests + beds!['small']!;
    numGuests = numGuests + beds!['medium']! * 2;
    numGuests = numGuests + beds!['large']! * 2;

    return numGuests;
  }

  String getBedroomText() {
    String text = "";
    if (beds!["small"] != 0) {
      text += beds!["small"].toString() + " single/twin ";
    }

    if (beds!["medium"] != 0) {
      text += beds!["medium"].toString() + " double ";
    }

    if (beds!["large"] != 0) {
      text += beds!["large"].toString() + " queen/king ";
    }

    return text;
  }

  String getBathroomText() {
    String text = "";
    if (bathrooms!["full"] != 0) {
      text += bathrooms!["full"].toString() + " full ";
    }

    if (bathrooms!["half"] != 0) {
      text += bathrooms!["half"].toString() + " half ";
    }

    return text;
  }

  String getFullAddress() {
    return address! + ", " + city! + ", " + country!;
  }

  getAllBookingsFromFirestore() async {
    bookings = [];

    QuerySnapshot snapshots = await FirebaseFirestore.instance
        .collection('postings')
        .doc(id)
        .collection('bookings')
        .get();

    for (var snapshot in snapshots.docs) {
      BookingModel newBooking = BookingModel();

      await newBooking.getBookingInfoFromFirestoreFromPosting(this, snapshot);

      bookings!.add(newBooking);
    }
  }

  List<DateTime> getAllBookedDates() {
    List<DateTime> dates = [];

    bookings!.forEach((booking) {
      dates.addAll(booking.dates!);
    });

    return dates;
  }

  Future<void> makeNewBooking(List<DateTime> dates, context) async {
    Map<String, dynamic> bookingData = {
      'dates': dates,
      'name': AppConstants.currentUser.getFullNameOfUser(),
      'userID': AppConstants.currentUser.id,
      'payment': bookingPrice,
    };

    DocumentReference reference = await FirebaseFirestore.instance
        .collection('postings')
        .doc(id)
        .collection('bookings')
        .add(bookingData);

    BookingModel newBooking = BookingModel();

    newBooking.createBooking(
        this, AppConstants.currentUser.createUserFromContact(), dates);
    newBooking.id = reference.id;

    bookings!.add(newBooking);
    await AppConstants.currentUser
        .addBookingToFirestore(newBooking, bookingPrice!);

    Get.snackbar("Listing", "Booked Successfully!");
  }
}
