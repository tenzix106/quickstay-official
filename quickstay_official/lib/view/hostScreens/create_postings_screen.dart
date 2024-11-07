import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickstay_official/global.dart';
import 'package:quickstay_official/model/app_constants.dart';
import 'package:quickstay_official/model/posting_model.dart';
import 'package:quickstay_official/view/guest_home_screen.dart';
import 'package:quickstay_official/view/host_home_screen.dart';
import 'package:quickstay_official/widgets/amenities_ui.dart';

class CreatePostingsScreen extends StatefulWidget {
  PostingModel? posting;

  CreatePostingsScreen({super.key, this.posting});

  @override
  State<CreatePostingsScreen> createState() => _CreatePostingsScreenState();
}

class _CreatePostingsScreenState extends State<CreatePostingsScreen> {
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

  List<MemoryImage>? _imagesList;

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

  _selectImageFromGallery(int index) async {
    var imageFilePickedFromGallery =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFilePickedFromGallery != null) {
      MemoryImage imageFileInBytesForm = MemoryImage(
          (File(imageFilePickedFromGallery.path)).readAsBytesSync());

      if (index < 0) {
        _imagesList!.add(imageFileInBytesForm);
      } else {
        _imagesList![index] = imageFileInBytesForm;
      }

      setState(() {});
    }
  }

  Future<void> _deletePosting() async {
    if (widget.posting != null) {
      // Show a confirmation dialog before deleting
      bool? confirmDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Listing"),
            content:
                const Text("Are you sure you want to delete this listing?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Delete"),
              ),
            ],
          );
        },
      );

      // If the user confirmed the deletion
      if (confirmDelete == true) {
        try {
          // Delete the posting from Firestore
          await FirebaseFirestore.instance
              .collection('postings')
              .doc(widget.posting!.id)
              .delete();

          await removePostingFromMyPostings(widget.posting!);

          // Refresh the UI
          setState(() {});

          Get.snackbar(
              "Delete Listing", "Your Listing has been deleted successfully!");
          Get.to(HostHomeScreen());
        } catch (e) {
          // Handle any errors that occur during deletion
          Get.snackbar("Error", "Failed to delete the listing: $e");
        }
      }
    }
  }

  Future<void> removePostingFromMyPostings(PostingModel posting) async {
    // Check if the posting exists in the local myPostings list
    if (AppConstants.currentUser.myPostings!.contains(posting)) {
      // Remove the posting from the local list
      AppConstants.currentUser.myPostings!.remove(posting);

      // Create a list to hold the updated posting IDs
      List<String> myPostingIDsList = [];

      // Populate the list with the remaining posting IDs
      AppConstants.currentUser.myPostings!.forEach((element) {
        myPostingIDsList.add(element.id!);
      });

      try {
        // Update the user's myPostingIDs field in Firestore
        await FirebaseFirestore.instance
            .collection("users")
            .doc(AppConstants.currentUser.id)
            .update({
          'myPostingIDs': myPostingIDsList,
        });

        // Optionally, you can show a success message
        Get.snackbar("Success", "Posting removed from your listings.");
      } catch (e) {
        // Handle any errors that occur during the Firestore update
        Get.snackbar("Error", "Failed to update your postings: $e");
      }
    } else {
      // Optionally handle the case where the posting was not found
      Get.snackbar("Info", "Posting not found in your listings.");
    }
  }

  @override
  void initState() {
    super.initState();
    initializeValues();
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
            maxLines: 1,
          ),
          actions: [
            IconButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                if (residenceTypeSelected == "") {
                  return;
                }

                if (_imagesList!.isEmpty) {
                  return;
                }

                postingModel.name = _nameTextEditingController.text;
                postingModel.price =
                    double.parse(_priceTextEditingController.text);
                postingModel.description =
                    _descriptionTextEditingController.text;
                postingModel.address = _addressTextEditingController.text;
                postingModel.city = _cityTextEditingController.text;
                postingModel.country = _countryTextEditingController.text;
                postingModel.amenities =
                    _amenitiesTextEditingController.text.split(",");
                postingModel.type = residenceTypeSelected;
                postingModel.beds = _beds;
                postingModel.bathrooms = _bathrooms;
                postingModel.displayImages = _imagesList;

                postingModel.host =
                    AppConstants.currentUser.createUserFromContact();

                postingModel.setImagesName();

                if (widget.posting == null) {
                  postingModel.rating = 3.5;
                  postingModel.bookings = [];
                  postingModel.reviews = [];

                  await postingViewModel.addListingInfoToFirestore();
                  await postingViewModel.addImagesToFirebaseStorage();

                  Get.snackbar("New Listing",
                      "Your New Listing is Uploaded Successfully!");
                } else {
                  postingModel.rating = widget.posting!.rating;
                  postingModel.bookings = widget.posting!.bookings;
                  postingModel.reviews = widget.posting!.reviews;
                  postingModel.id = widget.posting!.id;

                  for (int i = 0;
                      i < AppConstants.currentUser.myPostings!.length;
                      i++) {
                    if (AppConstants.currentUser.myPostings![i].id ==
                        postingModel.id) {
                      AppConstants.currentUser.myPostings![i] = postingModel;
                      break;
                    }
                  }

                  await postingViewModel.updatePostingInfoToFirestore();

                  Get.snackbar("Update Listing",
                      "Your Listing is Updated Successfully!");
                }

                postingModel = PostingModel();
                Get.to(HostHomeScreen());
              },
              icon: const Icon(Icons.upload),
            ),
            if (widget.posting !=
                null) // Show delete button only if editing an existing posting
              IconButton(
                onPressed: _deletePosting,
                icon: const Icon(Icons.delete),
              ),
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
                          // listing name
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
                              )),

                          // residence type
                          Padding(
                              padding: const EdgeInsets.only(top: 28.0),
                              child: DropdownButton(
                                  items: residenceTypes.map((item) {
                                    return DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ));
                                  }).toList(),
                                  onChanged: (valueItem) {
                                    setState(() {
                                      residenceTypeSelected =
                                          valueItem.toString();
                                    });
                                  },
                                  isExpanded: true,
                                  value: residenceTypeSelected,
                                  hint: const Text(
                                    "Select Property Type",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ))),

                          // price
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

                          // description
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
                              )),

                          // address
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
                              )),

                          // city
                          Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: TextFormField(
                                decoration:
                                    const InputDecoration(labelText: "City"),
                                style: const TextStyle(
                                  fontSize: 25.0,
                                ),
                                controller: _cityTextEditingController,
                                validator: (textInput) {
                                  if (textInput!.isEmpty) {
                                    return "Please Enter a Valid City";
                                  }
                                  return null;
                                },
                              )),

                          // country
                          Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: TextFormField(
                                decoration:
                                    const InputDecoration(labelText: "Country"),
                                style: const TextStyle(
                                  fontSize: 25.0,
                                ),
                                controller: _countryTextEditingController,
                                validator: (textInput) {
                                  if (textInput!.isEmpty) {
                                    return "Please Enter a Valid Name";
                                  }
                                  return null;
                                },
                              )),

                          // beds
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
                                // Twin/Single bed
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
                                ),

                                // Double Bed
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
                                ),

                                // Queen/King bed
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
                                )
                              ],
                            ),
                          ),

                          // Bathrooms
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
                                ),

                                //Half bathrooms

                                AmenitiesUI(
                                  type: 'Half',
                                  startValue: _bathrooms!['half']!,
                                  decreaseValue: () {
                                    _bathrooms!['half'] =
                                        _bathrooms!['half']! - 1;

                                    if (_bathrooms!['half']! < 0) {
                                      _bathrooms!['half'] = 0;
                                    }
                                  },
                                  increaseValue: () {
                                    _bathrooms!['half'] =
                                        _bathrooms!['half']! + 1;
                                  },
                                ),

                                // Amenities
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
                                    )),

                                // Photos
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
                                          return IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              _selectImageFromGallery(-1);
                                            },
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
