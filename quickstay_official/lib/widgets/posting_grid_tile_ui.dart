import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:quickstay_official/model/app_constants.dart';
import 'package:quickstay_official/model/posting_model.dart';

class PostingGridTileUi extends StatefulWidget {
  PostingModel? posting;
  PostingGridTileUi({super.key, this.posting});

  @override
  State<PostingGridTileUi> createState() => _PostingGridTileUiState();
}

class _PostingGridTileUiState extends State<PostingGridTileUi> {
  late PostingModel? posting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    posting = widget.posting!;

    updateUI();
  }

  Future<void> updateUI() async {
    await posting!.getFirstImageFromStorage();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 3 / 2,
          child: (posting!.displayImages!.isEmpty)
              ? Container()
              : Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: posting!.displayImages!.first,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
        ),
        Text(
          posting!.name!,
          maxLines: 3,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          posting!.type!,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "RM ${posting!.price!} / night",
          maxLines: 2,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            RatingBar.readOnly(
              size: 22.0,
              maxRating: 5,
              initialRating: posting!.rating!,
              filledIcon: Icons.star,
              emptyIcon: Icons.star_border,
              filledColor: Colors.yellow,
            ),
          ],
        )
      ],
    );
  }
}
