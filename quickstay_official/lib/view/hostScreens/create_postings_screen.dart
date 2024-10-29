import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickstay_official/widgets/amenities_ui.dart';

class CreatePostingsScreen extends StatefulWidget {
  const CreatePostingsScreen({super.key});

  @override
  State<CreatePostingsScreen> createState() => _CreatePostingsScreenState();
}




class _CreatePostingsScreenState extends State<CreatePostingsScreen> {

  final formKey = GlobalKey<FormState>();
  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _addressTextEditingController = TextEditingController();
  TextEditingController _cityTextEditingController = TextEditingController();
  TextEditingController _countryTextEditingController = TextEditingController();
  TextEditingController _amenitiesTextEditingController = TextEditingController();

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

  initializeValues()
  {
    _priceTextEditingController = TextEditingController(text: "");
    _descriptionTextEditingController = TextEditingController(text: "");
    _addressTextEditingController = TextEditingController(text: "");
    _cityTextEditingController = TextEditingController(text: "");
    _countryTextEditingController = TextEditingController(text: "");
    _amenitiesTextEditingController = TextEditingController(text: "");

    residenceTypeSelected = residenceTypes.first;

    _beds = {
      'small' : 0,
      'medium' : 0,
      'large' : 0,
    };
    _bathrooms = {
      'full' : 0,
      'half' : 0,
    };
    _imagesList = [];
  }

  _selectImageFromGallery(int index) async
  {
    var imageFilePickedFromGallery = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(imageFilePickedFromGallery != null)
    {
      MemoryImage imageFileInBytesForm = MemoryImage((File(imageFilePickedFromGallery.path)).readAsBytesSync());

      if (index < 0)
      {
        _imagesList!.add(imageFileInBytesForm);
      }
      else
      {
        _imagesList![index] = imageFileInBytesForm;
      }

      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializeValues();
  }

  @override
  Widget build(BuildContext context) 
  {
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
            onPressed: (){},
            icon: const Icon(Icons.upload),
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
                          decoration: const InputDecoration(labelText: "Listing Name"),
                          style: const TextStyle(
                            fontSize: 25.0,
                          ),
                          controller: _nameTextEditingController,
                          validator: (textInput)
                          {
                            if(textInput!.isEmpty)
                            {
                              return "Please Enter a Valid Name";
                            }
                            return null;
                          },
                        )
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: DropdownButton(
                          items: residenceTypes.map((item)
                          {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 20, 
                                ),
                              )
                            );
                          }).toList(),
                          onChanged: (valueItem){
                            setState(() {
                              residenceTypeSelected= valueItem.toString();
                            });
                          },
                          isExpanded: true,
                          value: residenceTypeSelected,
                          hint: const Text(
                            "Select Property Type",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        )
                      ),
                    
                    
                      Padding(
                        padding: const EdgeInsets.only(top: 21.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: "Price"),
                                style: const TextStyle(
                                  fontSize: 25.0,
                                ),
                                keyboardType: TextInputType.number,
                                controller: _priceTextEditingController,
                                validator: (text){
                                  if(text!.isEmpty){
                                    return "Please enter a valid price";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 10.0, bottom: 10.0
                              ),
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
                          decoration: const InputDecoration(labelText: "Description"),
                          style: const TextStyle(
                            fontSize: 25.0,
                          ),
                          controller: _descriptionTextEditingController,
                          maxLines: 3,
                          minLines: 1,
                          validator: (text)
                          {
                            if(text!.isEmpty)
                            {
                              return "Please Enter a Valid Description";
                            }
                            return null;
                          },
                        )
                      ),


                      //Address
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: TextFormField(
                          enabled: false,
                          decoration: const InputDecoration(labelText: "Address"),
                          maxLines: 3,
                          style: const TextStyle(
                            fontSize: 25.0,
                          ),
                          controller: _addressTextEditingController,
                          validator: (textInput)
                          {
                            if(textInput!.isEmpty)
                            {
                              return "Please Enter a Valid Address";
                            }
                            return null;
                          },
                        )
                      ),


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
                        padding: const EdgeInsets.only(left: 15, right: 15.0),
                        child: Column(
                          children: <Widget>[


                            //Twin/Single bed
                            AmenitiesUI(
                              type: 'Twin/Single',
                              startValue: _beds!['small']!,
                              decreaseValue: ()
                              {
                                _beds!['small'] = _beds!['small']! - 1;

                                if(_beds!['small']! < 0)
                                {
                                  _beds!['small'] = 0;
                                }
                              },
                              increaseValue: ()
                              {
                                _beds!['small'] = _beds!['small']! + 1;
                              },

                            ),

                            //Double Bed
                            AmenitiesUI(
                              type: 'Double',
                              startValue: _beds!['medium']!,
                              decreaseValue: ()
                              {
                                _beds!['medium'] = _beds!['medium']! - 1;

                                if(_beds!['medium']! < 0)
                                {
                                  _beds!['medium'] = 0;
                                }
                              },
                              increaseValue: ()
                              {
                                _beds!['medium'] = _beds!['medium']! + 1;
                              },


                            ),

                            //Queen/King bed
                            AmenitiesUI(
                              type: 'Queen/King',
                              startValue: _beds!['large']!,
                              decreaseValue: ()
                              {
                                _beds!['large'] = _beds!['large']! - 1;

                                if(_beds!['large']! < 0)
                                {
                                  _beds!['large'] = 0;
                                }
                              },
                              increaseValue: ()
                              {
                                _beds!['large'] = _beds!['large']! + 1;
                              },

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
                              decreaseValue: ()
                              {
                                _bathrooms!['full'] = _bathrooms!['full']! - 1;

                                if(_bathrooms!['full']! < 0)
                                {
                                  _bathrooms!['full'] = 0;
                                }
                              },
                              increaseValue: ()
                              {
                                _bathrooms!['full'] = _bathrooms!['full']! + 1;
                              },

                            ),

                            //Half bathrooms

                            AmenitiesUI(
                              type: 'Half',
                              startValue: _bathrooms!['half']!,
                              decreaseValue: ()
                              {
                                _bathrooms!['half'] = _bathrooms!['half']! - 1;

                                if(_bathrooms!['half']! < 0)
                                {
                                  _bathrooms!['half'] = 0;
                                }
                              },
                              increaseValue: ()
                              {
                                _bathrooms!['half'] = _bathrooms!['half']! + 1;
                              },

                            ),


                            Padding(
                              padding: const EdgeInsets.only(top: 21.0),
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: "Amenities, (coma seperated)"),
                                style: const TextStyle(
                                  fontSize: 25.0,
                                ),
                                controller: _amenitiesTextEditingController,
                                validator: (text)
                                {
                                  if(text!.isEmpty)
                                  {
                                    return "Please Enter Valid Amenities (coma seperated)";
                                  }
                                  return null;
                                },
                                maxLines: 3,
                                minLines: 1,
                              )
                            ),

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
                              padding: const EdgeInsets.only(top: 20.0, bottom: 25.0),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: _imagesList!.length + 1,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 25,
                                    crossAxisSpacing: 25,
                                    childAspectRatio: 3 / 2,
                                  ),
                                  itemBuilder: (context, index)
                                  {
                                    if (index == _imagesList!.length)
                                    {
                                      return IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () 
                                        {
                                          _selectImageFromGallery(-1);
                                        },
                                      );
                                    }
                                  return MaterialButton(
                                    onPressed: (){},
                                    child: Image(
                                        image: _imagesList![index],
                                        fit:BoxFit.fill,
                                    ),
                                  );
                                  },
                              )
                            ),

                          ],
                        ),
                      ),
                    
                    ],
                  ),
                ),


              ],
            )
          ),
        ),
      )
    
    
    );
  }
}