import 'package:quickstay_official/model/contact_model.dart';
import 'package:quickstay_official/model/posting_model.dart';

class BookingModel {
  String id = "";
  PostingModel? posting;
  ContactModel? contact;
  List<DateTime>? dates;

  BookingModel();
}
