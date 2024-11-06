import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickstay_official/model/app_constants.dart';
import 'package:quickstay_official/model/posting_model.dart';
import 'package:quickstay_official/view/guestScreens/book_listing_screen.dart';
import 'package:quickstay_official/widgets/posting_info_tile_ui.dart';

class ViewPostingScreen extends StatefulWidget {
  PostingModel? posting;

  ViewPostingScreen({super.key, this.posting});

  @override
  State<ViewPostingScreen> createState() => _ViewPostingScreenState();
}

class _ViewPostingScreenState extends State<ViewPostingScreen> {
  PostingModel? posting;
  bool isSaved = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    posting = widget.posting;

    loadPostingData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkSavedStatus(); // Check status on every re-entry
  }

  // load the necessary data of the posting
  Future<void> loadPostingData() async {
    await posting!.getAllImagesFromStorage();

    await posting!.getHostFromFirestore();

    await AppConstants.currentUser.getMySavedPostingsFromFireStore();

    checkSavedStatus();

    // update the UI with the loaded data
    setState(() {});
  }

  void checkSavedStatus() async {
    await AppConstants.currentUser.getMySavedPostingsFromFireStore();

    List<String> savedIDs = AppConstants.currentUser.savedPostings!
        .map((posting) => posting.id!)
        .toList();

    print("Updated savedPosting IDs: $savedIDs");
    print("Current Posting ID: ${posting!.id}");

    setState(() {
      isSaved = savedIDs.contains(posting!.id);
      print("Check Saved Status After Refresh: $isSaved");
    });
  }

  void toggleSavedPosting() async {
    if (isSaved) {
      await AppConstants.currentUser.removeSavedPosting(posting!);

      setState(() {
        isSaved = false;
      });
    } else {
      await AppConstants.currentUser.addSavedPosting(posting!);

      setState(() {
        isSaved = true;
      });
    }

    print("Save Listing Status: $isSaved");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 76, 215, 208),
                Color.fromARGB(255, 164, 232, 224),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text(
          'Posting Information',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: isSaved ? Colors.red : Colors.white,
            ),
            onPressed: () {
              toggleSavedPosting();
              //AppConstants.currentUser.addSavedPosting(posting!);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // listing images
            AspectRatio(
              aspectRatio: 3 / 2,
              child: PageView.builder(
                itemCount: posting!.displayImages!.length,
                itemBuilder: (context, index) {
                  MemoryImage currentImage = posting!.displayImages![index];
                  return Image(
                    image: currentImage,
                    fit: BoxFit.fill,
                  );
                },
              ),
            ),

            // posting details

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // posting name
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.55,
                        child: Text(
                          posting!.name!.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                          maxLines: 3,
                        ),
                      ),
                      // book now btn - price
                      Column(
                        children: <Widget>[
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 76, 215, 208),
                                  Color.fromARGB(255, 164, 232, 224),
                                ],
                                begin: FractionalOffset(0.0, 0.0),
                                end: FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp,
                              ),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                Get.to(BookListingScreen(
                                  posting: posting,
                                  hostID: posting!.host!.id!,
                                ));
                              },
                              child: const Text(
                                'Book Now',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Text(
                            'MYR ${posting!.price} / night',
                            style: const TextStyle(fontSize: 12.0),
                          ),
                        ],
                      )
                    ],
                  ),

                  // description - profile pic - name
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 35.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.75,
                          child: Text(
                            posting!.description!,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                            maxLines: 6,
                          ),
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: CircleAvatar(
                                radius:
                                    MediaQuery.of(context).size.width / 12.5,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  backgroundImage: posting!.host!.displayImage,
                                  radius:
                                      MediaQuery.of(context).size.width / 13,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                posting!.host!.getFullNameOfUser(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  // apartments - beds - bathrooms
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        PostingInfoTileUI(
                          iconData: Icons.home,
                          category: posting!.type!,
                          categoryInfo: '${posting!.getGuestsNumber()} guests',
                        ),
                        PostingInfoTileUI(
                          iconData: Icons.hotel,
                          category: 'Beds',
                          categoryInfo: posting!.getBedroomText(),
                        ),
                        PostingInfoTileUI(
                          iconData: Icons.wc,
                          category: 'Bathrooms',
                          categoryInfo: posting!.getBathroomText(),
                        ),
                      ],
                    ),
                  ),

                  //amenities
                  const Text(
                    'Amenitites: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 25),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 3.6,
                      children:
                          List.generate(posting!.amenities!.length, (index) {
                        String currentAmenity = posting!.amenities![index];
                        return Chip(
                          label: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              currentAmenity,
                              style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          backgroundColor: Colors.white10,
                        );
                      }),
                    ),
                  ),

                  // Location
                  const Text(
                    'Location: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 35),
                      child: Text(
                        posting!.getFullAddress(),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
