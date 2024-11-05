import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickstay_official/model/posting_model.dart';
import 'package:quickstay_official/widgets/posting_list_tile_ui.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VerifyPostingsScreen extends StatefulWidget {
  const VerifyPostingsScreen({Key? key}) : super(key: key);

  @override
  State<VerifyPostingsScreen> createState() => _VerifyPostingsScreenState();
}

class _VerifyPostingsScreenState extends State<VerifyPostingsScreen> {
  String? id;
  List<PostingModel> unverifiedPostings = [];
  List<MemoryImage>? displayImages = [];
  List<String>? imageNames;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUnverifiedPostings();
  }

  Future<void> loadUnverifiedPostings() async {
    PostingModel postingModel = PostingModel();
    
    // Fetch unverified postings from Firestore
    unverifiedPostings = await postingModel.getUnverifiedPostingsFromFirestore();
    
    // Initialize displayImages list
    displayImages = [];

    // Retrieve display images from storage for each posting
    for (var posting in unverifiedPostings) {
      List<MemoryImage> images = await getImagesFromStorage(posting);
      displayImages!.addAll(images);
    }
    print(displayImages);

    setState(() {
      isLoading = false; // Update loading state
    });
  }

  Future<void> verifyPosting(PostingModel posting) async {
    await FirebaseFirestore.instance
        .collection('postings')
        .doc(posting.id)
        .update({'verified': true});

    setState(() {
      unverifiedPostings.remove(posting);
    });

    Get.snackbar("Posting Verified", "The posting has been verified successfully.");
  }
  Future<List<MemoryImage>> getImagesFromStorage(PostingModel posting) async {
  List<MemoryImage> displayImages = [];

  // Ensure imageNames is not null and has values
  if (posting.imageNames != null) {
    for (String imageName in posting.imageNames!) {
      // Fetch image data from Firebase Storage
      final imageData = await FirebaseStorage.instance
          .ref()
          .child("postingImages")
          .child(posting.id!) // Use posting.id instead of id
          .child(imageName)
          .getData(2048 * 2048);

      if (imageData != null) {
        // Add the image to the list if data is not null
        displayImages.add(MemoryImage(imageData));
      }
    }
  }
  
  return displayImages; // Return the list of MemoryImages
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Postings"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : unverifiedPostings.isEmpty
                ? Center(child: Text("No unverified postings available."))
                : ListView.builder(
                    itemCount: unverifiedPostings.length,
                    itemBuilder: (context, index) {
                      PostingModel posting = unverifiedPostings[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(26, 0, 26, 26),
                        child: InkResponse(
                          onTap: () {
                            // Define action when tapping on posting if needed
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.2,
                              ),
                            ),
                            child: Column(
                              children: [
                                PostingListTileUi(posting: posting),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
