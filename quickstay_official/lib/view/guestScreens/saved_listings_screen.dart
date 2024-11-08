import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickstay_official/model/app_constants.dart';
import 'package:quickstay_official/model/posting_model.dart';
import 'package:quickstay_official/widgets/posting_grid_tile_ui.dart';
import 'package:quickstay_official/widgets/view_posting_screen.dart';

class SavedListingsScreen extends StatefulWidget {
  const SavedListingsScreen({super.key});

  @override
  State<SavedListingsScreen> createState() => _SavedListingsScreenState();
}

class _SavedListingsScreenState extends State<SavedListingsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadSavedListing();
  }

  void loadSavedListing() async {
    //AppConstants.currentUser.savedPostings?.clear();

    await AppConstants.currentUser.getMySavedPostingsFromFireStore();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
      child: GridView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: AppConstants.currentUser.savedPostings!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            PostingModel currentPosting =
                AppConstants.currentUser.savedPostings![index];

            return Stack(
              children: [
                InkResponse(
                  enableFeedback: true,
                  child: PostingGridTileUi(
                    posting: currentPosting,
                  ),
                  onTap: () {
                    Get.to(ViewPostingScreen(
                      posting: currentPosting,
                    ));
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Container(
                      width: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        onPressed: () {
                          AppConstants.currentUser
                              .removeSavedPosting(currentPosting);

                          setState(() {});
                        },
                        padding: const EdgeInsets.all(0),
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                //
              ],
            );
          }),
    );
  }
}
