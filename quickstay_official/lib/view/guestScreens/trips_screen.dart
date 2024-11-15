import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickstay_official/model/app_constants.dart';
import 'package:quickstay_official/model/booking_model.dart';
import 'package:quickstay_official/model/posting_model.dart';
import 'package:quickstay_official/widgets/booking_list_tile_ui.dart';
import 'package:quickstay_official/widgets/posting_list_tile_button.dart';
import 'package:quickstay_official/widgets/posting_list_tile_ui.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  List<String> allBookings = [];
  List<BookingModel> allBookingsModel = [];

  @override
  void initState() {
    super.initState();
    getAllBookings();
  }

  getAllBookings() async {
    QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(AppConstants.currentUser.id)
        .collection('bookings')
        .get();

    for (var booking in bookingSnapshot.docs) {
      BookingModel newBookingModel = BookingModel();

      // Assuming your booking document contains a field for postingID
      String postingID =
          booking['postingID']; // Adjust based on your Firestore structure

      PostingModel postingModel = PostingModel();

      // Fetch the posting data using the new method
      await postingModel.fetchAndPopulatePostingData(postingID);

      // Load booking info into the BookingModel
      await newBookingModel.getBookingInfoFromFirestoreFromUser(
          postingModel, booking);

      print(postingModel.imageNames);

      // Add the populated BookingModel to the list
      allBookings.add(postingID);
      allBookingsModel.add(newBookingModel);
    }

    // Refresh the UI after loading the bookings
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 25),
        child: ListView.builder(
            itemCount: allBookings.length + 1,
            itemBuilder: (context, index) {
              if (index == allBookings.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "This is the end of your bookings.",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(26, 0, 26, 20),
                  child: InkResponse(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: BookingListTileUi(
                        booking: allBookingsModel[index],
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}
