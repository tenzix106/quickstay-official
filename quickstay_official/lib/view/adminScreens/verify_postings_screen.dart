import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickstay_official/global.dart';
import 'package:quickstay_official/model/app_constants.dart';
import 'package:quickstay_official/model/posting_model.dart';
import 'package:quickstay_official/view/guest_home_screen.dart';
import 'package:quickstay_official/view/host_home_screen.dart';
import 'package:quickstay_official/widgets/amenities_ui.dart';

class VerifyPostingsScreen extends StatefulWidget {
  PostingModel? posting;
  VerifyPostingsScreen({super.key, this.posting});

  @override
  State<VerifyPostingsScreen> createState() => _VerifyPostingsScreenState();
}

class _VerifyPostingsScreenState extends State<VerifyPostingsScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _descriptionTextEditingController =
      TextEditingController();
  TextEditingController _addressTextEditingController = TextEditingController();
  TextEditingController _cityTextEditingController = TextEditingController();
  TextEditingController _countryTextEditingController = TextEditingController();
  TextEditingController _amenitiesTextEditingController =
      TextEditingController();
  final List<String> residenceTypes = [
    'Detached House',
    'Villa',
    'Apartment',
    'Condo',
    'Flat',
    'Town House',
    'Studio',
  ];

  String residenceTypeSelected = "";

  Map<String, int>? _beds;
  Map<String, int>? _bathrooms;
  List<PostingModel> unverifiedPostings = [];
  List<MemoryImage>? displayImages = [];
  List<String>? imageNames;

  bool isLoading = true;

  List<MemoryImage>? _imagesList;
  Future<void> loadUnverifiedPostings() async {
    PostingModel postingModel = PostingModel();

    // Fetch unverified postings from Firestore
    unverifiedPostings =
        await postingModel.getUnverifiedPostingsFromFirestore();

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

    Get.snackbar(
        "Posting Verified", "The posting has been verified successfully.");
    Get.to(VerifyPostingsScreen());
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

  initializeValues() {
    if (widget.posting == null) {
      _nameTextEditingController = TextEditingController(text: "");
      _priceTextEditingController = TextEditingController(text: "");
      _descriptionTextEditingController = TextEditingController(text: "");
      _addressTextEditingController = TextEditingController(text: "");
      _cityTextEditingController = TextEditingController(text: "");
      _countryTextEditingController = TextEditingController(text: "");
      _amenitiesTextEditingController = TextEditingController(text: "");

      residenceTypeSelected = residenceTypes.first;

      _beds = {
        'small': 0,
        'medium': 0,
        'large': 0,
      };
      _bathrooms = {
        'full': 0,
        'half': 0,
      };
      _imagesList = [];
    } else {
      _nameTextEditingController =
          TextEditingController(text: widget.posting!.name);
      _priceTextEditingController =
          TextEditingController(text: widget.posting!.price.toString());
      _descriptionTextEditingController =
          TextEditingController(text: widget.posting!.description);
      _addressTextEditingController =
          TextEditingController(text: widget.posting!.address);
      _cityTextEditingController =
          TextEditingController(text: widget.posting!.city);
      _countryTextEditingController =
          TextEditingController(text: widget.posting!.country);
      _amenitiesTextEditingController =
          TextEditingController(text: widget.posting!.getAmenitiesString());
      _beds = widget.posting!.beds;
      _bathrooms = widget.posting!.bathrooms;
      _imagesList = widget.posting!.displayImages;
      residenceTypeSelected = widget.posting!.type!;
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializeValues();
    loadUnverifiedPostings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(76, 215, 208, 100),
            ),
          ),
          title: const Text(
            "Create / Update a Listing",
            overflow: TextOverflow.ellipsis,
            maxLines: 1, // keeps it on one line
          ),
          actions: [
            IconButton(
              onPressed: () async {
                // Ensure that the posting model is not null
                if (widget.posting == null) {
                  Get.snackbar("Error", "No posting to verify.");
                  return;
                }

                // Call the verifyPosting function with the current posting model
                await verifyPosting(widget.posting!);
              },
              icon: const Icon(
                  Icons.check), // Change icon to indicate verification
            )
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(26, 26, 26, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "Listing Name"),
                                style: const TextStyle(
                                  fontSize: 25.0,
                                ),
                                controller: _nameTextEditingController,
                                validator: (textInput) {
                                  if (textInput!.isEmpty) {
                                    return "Please Enter a Valid Name";
                                  }
                                  return null;
                                },
                                readOnly: true,
                              )),

                          Padding(
                            padding: const EdgeInsets.only(top: 28.0),
                            child: GestureDetector(
                              onTap: () {
                                // Do nothing or show a message indicating that it's disabled
                              },
                              child: DropdownButton(
                                items: residenceTypes.map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged:
                                    null, // Set onChanged to null to disable interaction
                                isExpanded: true,
                                value: residenceTypeSelected,
                                hint: const Text(
                                  "Select Property Type",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 21.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: "Price"),
                                    style: const TextStyle(
                                      fontSize: 25.0,
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: _priceTextEditingController,
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return "Please enter a valid price";
                                      }
                                      return null;
                                    },
                                    readOnly: true,
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, bottom: 10.0),
                                  child: Text(
                                    "MYR / night",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          //description
                          Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "Description"),
                                style: const TextStyle(
                                  fontSize: 25.0,
                                ),
                                controller: _descriptionTextEditingController,
                                maxLines: 3,
                                minLines: 1,
                                validator: (text) {
                                  if (text!.isEmpty) {
                                    return "Please Enter a Valid Description";
                                  }
                                  return null;
                                },
                                readOnly: true,
                              )),

                          //Address
                          Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: TextFormField(
                                decoration:
                                    const InputDecoration(labelText: "Address"),
                                maxLines: 3,
                                style: const TextStyle(
                                  fontSize: 25.0,
                                ),
                                controller: _addressTextEditingController,
                                validator: (textInput) {
                                  if (textInput!.isEmpty) {
                                    return "Please Enter a Valid Address";
                                  }
                                  return null;
                                },
                                readOnly: true,
                              )),

                          //Beds
                          const Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Text(
                              'Beds',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15, right: 15.0),
                            child: Column(
                              children: <Widget>[
                                //Twin/Single bed
                                AmenitiesUI(
                                  type: 'Twin/Single',
                                  startValue: _beds!['small']!,
                                  decreaseValue: () {
                                    _beds!['small'] = _beds!['small']! - 1;

                                    if (_beds!['small']! < 0) {
                                      _beds!['small'] = 0;
                                    }
                                  },
                                  increaseValue: () {
                                    _beds!['small'] = _beds!['small']! + 1;
                                  },
                                  isEditable: false,
                                ),

                                //Double Bed
                                AmenitiesUI(
                                  type: 'Double',
                                  startValue: _beds!['medium']!,
                                  decreaseValue: () {
                                    _beds!['medium'] = _beds!['medium']! - 1;

                                    if (_beds!['medium']! < 0) {
                                      _beds!['medium'] = 0;
                                    }
                                  },
                                  increaseValue: () {
                                    _beds!['medium'] = _beds!['medium']! + 1;
                                  },
                                  isEditable: false,
                                ),

                                //Queen/King bed
                                AmenitiesUI(
                                  type: 'Queen/King',
                                  startValue: _beds!['large']!,
                                  decreaseValue: () {
                                    _beds!['large'] = _beds!['large']! - 1;

                                    if (_beds!['large']! < 0) {
                                      _beds!['large'] = 0;
                                    }
                                  },
                                  increaseValue: () {
                                    _beds!['large'] = _beds!['large']! + 1;
                                  },
                                  isEditable: false,
                                )

                                //Bathrooms
                              ],
                            ),
                          ),

                          const Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Text(
                              'Bathrooms',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
                            child: Column(
                              children: <Widget>[
                                //Full bathrooms

                                AmenitiesUI(
                                  type: 'Full',
                                  startValue: _bathrooms!['full']!,
                                  decreaseValue: () {
                                    _bathrooms!['full'] =
                                        _bathrooms!['full']! - 1;

                                    if (_bathrooms!['full']! < 0) {
                                      _bathrooms!['full'] = 0;
                                    }
                                  },
                                  increaseValue: () {
                                    _bathrooms!['full'] =
                                        _bathrooms!['full']! + 1;
                                  },
                                  isEditable: false,
                                ),

                                //Half bathrooms

                                AmenitiesUI(
                                  type: 'Half',
                                  startValue: _bathrooms!['half']!,
                                  decreaseValue:
                                      () {}, // No-op function to prevent decrease
                                  increaseValue:
                                      () {}, // No-op function to prevent increase
                                  isEditable: false,
                                ),

                                Padding(
                                    padding: const EdgeInsets.only(top: 21.0),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          labelText:
                                              "Amenities, (coma seperated)"),
                                      style: const TextStyle(
                                        fontSize: 25.0,
                                      ),
                                      controller:
                                          _amenitiesTextEditingController,
                                      validator: (text) {
                                        if (text!.isEmpty) {
                                          return "Please Enter Valid Amenities (coma seperated)";
                                        }
                                        return null;
                                      },
                                      maxLines: 3,
                                      minLines: 1,
                                      readOnly: true,
                                    )),

                                const Padding(
                                  padding: EdgeInsets.only(top: 30.0),
                                  child: Text(
                                    'Photos',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, bottom: 25.0),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: _imagesList!.length + 1,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 25,
                                        crossAxisSpacing: 25,
                                        childAspectRatio: 3 / 2,
                                      ),
                                      itemBuilder: (context, index) {
                                        if (index == _imagesList!.length) {
                                          return Container(
                                            color: Colors
                                                .grey, // Placeholder for no image
                                            alignment: Alignment
                                                .center, // Center the child within the container
                                            child: Text(
                                              "No Other Image Available",
                                              textAlign: TextAlign
                                                  .center, // Center the text itself
                                            ),
                                          );
                                        }
                                        return MaterialButton(
                                          onPressed: () {},
                                          child: Image(
                                            image: _imagesList![index],
                                            fit: BoxFit.fill,
                                          ),
                                        );
                                      },
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}
