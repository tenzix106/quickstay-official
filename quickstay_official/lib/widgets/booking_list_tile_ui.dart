import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  bool isLoadingImages = true; // Flag  to indicate if images are loading

  @override
  void initState() {
    super.initState();
    booking = widget.booking;
    // _loadPostingData();
  }

  Future<void> _loadPostingData() async {
    if (widget.booking == null) return;

    final postingDoc = await FirebaseFirestore.instance
        .collection('postings')
        .doc(booking!.postingID)
        .get();

    if (postingDoc.exists) {
      setState(() {
        posting = PostingModel.fromFirestore(postingDoc);
      });

      // Fetch images from Firebase Storage
      await posting!.getAllImagesFromStorage();

      // Update UI after loading images
      setState(() {
        isLoadingImages = false;
      });
    }
  }

  // _loadPostingImages() async {
  //   List<MemoryImage> images = [];
  //   posting?.getFirstImageFromStorage();
  //   for (int i = 0; i < posting!.imageNames!.length; i++) {
  //     final imageData = await FirebaseFirestore.instance
  //         .ref()
  //         .child('postingImages')
  //         .child(booking?.posting?.id)
  //         .child('image0.png')
  //         .getData(2048 * 2048);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Check if booking is null
    if (widget.booking == null) {
      return const ListTile(
        title: Text("You have not made any booking yet."),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        leading: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            booking?.posting?.name ?? "No Name Available",
            maxLines: 2,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        trailing: AspectRatio(
          aspectRatio: 3 / 2,
          child: isLoadingImages ||
                  booking?.posting?.displayImages == null ||
                  booking!.posting!.displayImages!.isEmpty
              ? Container(
                  color: Colors.grey,
                  child: const Center(
                    child: Text("No Image Available"),
                  ),
                )
              : Image(
                  image: posting?.getFirstImageFromStorage(),
                  fit: BoxFit.fitWidth,
                ),
        ),
      ),
    );
  }
}
