import 'package:flutter/material.dart';
import 'package:quickstay_official/model/posting_model.dart';

class PostingListTileUi extends StatefulWidget {
  final PostingModel? posting;
  PostingListTileUi({Key? key, this.posting}) : super(key: key);

  @override
  State<PostingListTileUi> createState() => _PostingListTileUiState();
}

class _PostingListTileUiState extends State<PostingListTileUi> {
  PostingModel? posting;

  @override
  void initState() {
    super.initState();
    posting = widget.posting;
  }

  @override
  Widget build(BuildContext context) {
    // Check if posting is null
    if (widget.posting == null) {
      return ListTile(
        title: Text("No Posting Available"),
      );
    }

    // Extract posting for easier access
    final posting = widget.posting!;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            posting.name ?? "No Name Available", // Handle null name
            maxLines: 2,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        trailing: AspectRatio(
          aspectRatio: 3 / 2,
          child: posting.displayImages != null && posting.displayImages!.isNotEmpty
              ? Image(
                  image: posting.displayImages!.first,
                  fit: BoxFit.fitWidth,
                )
              : Container(
                  color: Colors.grey, // Placeholder for no image
                  child: Center(child: Text("No Image Available")),
                ),
        ),
      ),
    );
  }
}
