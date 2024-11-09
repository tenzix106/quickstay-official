import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickstay_official/model/contact_model.dart';
import 'package:quickstay_official/model/posting_model.dart';

class BookingModel {
  String id = "";
  PostingModel? posting;
  ContactModel? contact;
  List<DateTime>? dates;

  BookingModel();

  String? get postingID => null;

  getBookingInfoFromFirestoreFromPosting(
      PostingModel posting, DocumentSnapshot snapshot) async {
    posting = posting;
    List<Timestamp> timestamps = List<Timestamp>.from(snapshot['dates']) ?? [];

    dates = [];
    timestamps.forEach((timestamp) {
      dates!.add(timestamp.toDate());
    });

    String contactID = snapshot['userID'] ?? "";
    String fullName = snapshot['name'] ?? "";

    _loadContactInfo(id, fullName);

    contact = ContactModel(id: contactID);
  }

  getBookingInfoFromFirestoreFromUser(
      PostingModel posting, DocumentSnapshot snapshot) async {
    this.posting = posting;
    List<Timestamp> timestamps = List<Timestamp>.from(snapshot['dates']) ?? [];

    dates = [];
    timestamps.forEach((timestamp) {
      dates!.add(timestamp.toDate());
    });
  }

  _loadContactInfo(String id, String fullName) {
    String firstName = "";
    String lastName = "";
    firstName = fullName.split(" ")[0];
    lastName = fullName.split(" ")[1];

    contact = ContactModel(id: id, firstName: firstName, lastName: lastName);
  }

  createBooking(
      PostingModel postingM, ContactModel contactM, List<DateTime> datesM) {
    posting = postingM;
    contact = contactM;
    dates = datesM;
    dates!.sort();
  }
}
