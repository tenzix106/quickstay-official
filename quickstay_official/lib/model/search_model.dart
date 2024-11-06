import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickstay_official/global.dart';
import 'package:quickstay_official/model/app_constants.dart';
import 'package:quickstay_official/model/posting_model.dart';

class SearchModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // retrieve postings based on filters
  Future<List<PostingModel>> getFilteredPostings({
    String? name,
    String? city,
    String? type,
  }) async {
    CollectionReference postingRef = _firestore.collection('property');

    Query query = postingRef;
    if (name != null && name.isNotEmpty) {
      query = query.where('name', isEqualTo: name);
    }

    if (city != null && city.isNotEmpty) {
      query = query.where('city', isEqualTo: city);
    }

    if (type != null && type.isNotEmpty) {
      query = query.where('type', isEqualTo: type);
    }

    final QuerySnapshot snapshot = await query.get();
    final List<PostingModel> postings =
        snapshot.docs.map((doc) => PostingModel.fromFirestore(doc)).toList();

    return postings;
  }
}
