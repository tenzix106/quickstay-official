import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:quickstay_official/global.dart';
import 'package:quickstay_official/model/app_constants.dart';
import 'package:quickstay_official/model/posting_model.dart';

class PostingViewModel {
  addListingInfoToFirestore() async {
    postingModel.setImagesName();

    Map<String, dynamic> dataMap = {
      "address": postingModel.address,
      "amenities": postingModel.amenities,
      "bathrooms": postingModel.bathrooms,
      "description": postingModel.description,
      "beds": postingModel.beds,
      "city": postingModel.city,
      "country": postingModel.country,
      "hostId": AppConstants.currentUser.id,
      "imageNames": postingModel.imageNames,
      "name": postingModel.name,
      "price": postingModel.price,
      "rating": 3.5,
      "type": postingModel.type,
      "verified": false,
    };

    DocumentReference ref =
        await FirebaseFirestore.instance.collection("postings").add(dataMap);
    postingModel.id = ref.id;

    await AppConstants.currentUser.addPostingToMyPostings(postingModel);
  }

  updatePostingInfoToFirestore() async {
    postingModel.setImagesName();

    Map<String, dynamic> dataMap = {
      "address": postingModel.address,
      "amenities": postingModel.amenities,
      "bathrooms": postingModel.bathrooms,
      "description": postingModel.description,
      "beds": postingModel.beds,
      "city": postingModel.city,
      "country": postingModel.country,
      "hostId": AppConstants.currentUser.id,
      "imageNames": postingModel.imageNames,
      "name": postingModel.name,
      "price": postingModel.price,
      "rating": 3.5,
      "type": postingModel.type,
    };

    FirebaseFirestore.instance
        .collection("postings")
        .doc(postingModel.id)
        .update(dataMap);
  }

  addImagesToFirebaseStorage() async {
    for (int i = 0; i < postingModel.displayImages!.length; i++) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("postingImages")
          .child(postingModel.id!)
          .child(postingModel.imageNames![i]);
      await ref
          .putData(postingModel.displayImages![i].bytes)
          .whenComplete(() {});
    }
  }
}
