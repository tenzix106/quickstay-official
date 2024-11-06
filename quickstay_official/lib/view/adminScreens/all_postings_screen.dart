import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickstay_official/global.dart';
import 'package:quickstay_official/model/app_constants.dart';
import 'package:quickstay_official/view/hostScreens/create_postings_screen.dart';
import 'package:quickstay_official/widgets/posting_list_tile_button.dart';
import 'package:quickstay_official/widgets/posting_list_tile_ui.dart';
import 'package:quickstay_official/model/posting_model.dart'; 

class AllPostingsScreen extends StatefulWidget {
  const AllPostingsScreen({super.key});

  @override
  State<AllPostingsScreen> createState() => AllPostingsScreenState();
}

class AllPostingsScreenState extends State<AllPostingsScreen> {
  List<PostingModel> allPostings = [];
  List<MemoryImage>? displayImages = [];
  List<String>? imageNames;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllPostings();
  }

  Future<void> fetchAllPostings() async {
    PostingModel postingModel = PostingModel();
    
    // Fetch unverified postings from Firestore
    allPostings = await postingModel.getAllPostingInfoFromFirestore();
    
    // Initialize displayImages list
    displayImages = [];

    // Retrieve display images from storage for each posting
    for (var posting in allPostings) {
      List<MemoryImage> images = await getImagesFromStorage(posting);
      displayImages!.addAll(images);
    }
    print(displayImages);

    setState(() {
      isLoading = false; // Update loading state
    });
  }
  getImagesFromStorage(PostingModel posting) async {
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
  return Padding(
    padding: const EdgeInsets.only(top: 25),
    child: isLoading
        ? Center(child: CircularProgressIndicator()) // Show loading indicator
        : ListView.builder(
            itemCount: allPostings.length, // Set itemCount to allPostings.length
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(26, 0, 26, 26),
                child: InkResponse(
                  onTap: () {
                    Get.to(CreatePostingsScreen(
                      posting: allPostings[index], // Directly access the posting
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.2,
                      ),
                    ),
                    child: PostingListTileUi(posting: allPostings[index]), // Only display PostingListTileUi
                  ),
                ),
              );
            },
          ),
  );
}
}