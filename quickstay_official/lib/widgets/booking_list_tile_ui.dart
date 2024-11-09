import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickstay_official/model/app_constants.dart';
import 'package:quickstay_official/model/booking_model.dart';
import 'package:quickstay_official/model/posting_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BookingListTileUi extends StatefulWidget {
  final BookingModel? booking;

  BookingListTileUi({
    super.key,
    this.booking,
  });

  @override
  State<BookingListTileUi> createState() => _BookingListTileUiState();
}

class _BookingListTileUiState extends State<BookingListTileUi> {
  BookingModel? booking;
  PostingModel? posting;
  List<MemoryImage>? displayImages; // List to store loaded images
  bool isLoadingImages = true; // Flag  to indicate if images are loading

  @override
  void initState() {
    super.initState();
    booking = widget.booking;
    loadPostingData();
  }

  Future<void> loadPostingData() async {
    if (widget.booking == null) return;

    displayImages = [];

    if (booking!.posting?.id != null) {
      List<MemoryImage> images =
          await getBookingImagesFromStorage(booking!.posting!);
      displayImages!.addAll(images);

      // Update UI after loading images
      setState(() {
        isLoadingImages = false;
      });
    }
  }

  Future<void> loadBookingData() async {
    if (widget.booking == null) return;

    String? userID = AppConstants.currentUser.id;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('bookings')
        .doc(booking!.id)
        .get();

    if (userDoc.exists) {
      booking!.dates = List<DateTime>.from(
          userDoc['dates'].map((date) => (date as Timestamp).toDate()));
    }

    await loadPostingData();
  }

  Future<List<MemoryImage>> getBookingImagesFromStorage(
      PostingModel posting) async {
    List<MemoryImage> displayImages = [];

    print(posting.name);

    if (posting.imageNames != null) {
      for (String imageName in posting.imageNames!) {
        final imageData = await FirebaseStorage.instance
            .ref()
            .child("postingImages")
            .child(posting.id!)
            .child(imageName)
            .getData(2048 * 2048);

        print("Fetching Image: $imageName");

        // Add the image to the list if it exists in the storage
        if (imageData != null) {
          displayImages.add(MemoryImage(imageData));
          print("Image fetched: $imageName");
        } else {
          print("Image not found: $imageName");
        }
      }
    } else {
      print("No image names found for posting: ${posting.id}");
    }

    return displayImages;
  }

  @override
  Widget build(BuildContext context) {
    // Check if booking is null
    if (widget.booking == null) {
      return const ListTile(
        title: Text("You have not made any booking yet."),
      );
    }

    String rentalPeriod = "";
    if (booking?.dates != null && booking!.dates!.isNotEmpty) {
      DateTime startDate = booking!.dates!.first;
      DateTime endDate = booking!.dates!.last;
      rentalPeriod =
          "Period: ${DateFormat('dd MMM').format(startDate)} - ${DateFormat('dd MMM').format(endDate)}";
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        leading: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking?.posting?.name ?? "No Name Available",
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                rentalPeriod.isNotEmpty
                    ? rentalPeriod
                    : "Rental Period Data Not Found",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
        ),
        trailing: AspectRatio(
          aspectRatio: 3 / 2,
          child:
              isLoadingImages || displayImages == null || displayImages!.isEmpty
                  ? Container(
                      color: Colors.grey,
                      child: const Center(
                        child: Text("No Image Available"),
                      ),
                    )
                  : Image(
                      image: displayImages!.first,
                      fit: BoxFit.fitWidth,
                    ),
        ),
      ),
    );
  }
}
