import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickstay_official/model/posting_model.dart';
import 'package:quickstay_official/widgets/posting_grid_tile_ui.dart';
import 'package:quickstay_official/widgets/view_posting_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController controllerSearch = TextEditingController();
  late Stream<QuerySnapshot> stream; // Declare the stream variable
  String searchType = "";

  bool isNameButtonSelected = false;
  bool isCityButtonSelected = false;
  bool isTypeButtonSelected = false;

  @override
  void initState() {
    super.initState();

    // Load all postings first
    stream = FirebaseFirestore.instance
        .collection('postings')
        .where('verified', isEqualTo: true)
        .snapshots();
  }

  void pressSearchByButton(String searchTypeStr, bool isNameButtonSelectedB,
      bool isCityButtonSelectedB, bool isTypeButtonSelectedB) {
    setState(() {
      searchType = searchTypeStr;
      isNameButtonSelected = isNameButtonSelectedB;
      isCityButtonSelected = isCityButtonSelectedB;
      isTypeButtonSelected = isTypeButtonSelectedB;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 20, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: const InputDecoration(
                  hintText: 'Search',
                  prefix: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(5.0)),
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              controller: controllerSearch,
              onChanged: (value) {
                setState(() {}); // Trigger rebuild to filter results
              },
            ),

            // Filter buttons
            SizedBox(
              height: 48,
              width: MediaQuery.of(context).size.width / .5,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                children: [
                  MaterialButton(
                    onPressed: () {
                      pressSearchByButton("name", true, false, false);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color:
                        isNameButtonSelected ? Colors.pinkAccent : Colors.white,
                    child: const Text("Name"),
                  ),
                  const SizedBox(width: 6),
                  MaterialButton(
                    onPressed: () {
                      pressSearchByButton("city", false, true, false);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color:
                        isCityButtonSelected ? Colors.pinkAccent : Colors.white,
                    child: const Text("City"),
                  ),
                  const SizedBox(width: 6),
                  MaterialButton(
                    onPressed: () {
                      pressSearchByButton("type", false, false, true);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color:
                        isTypeButtonSelected ? Colors.pinkAccent : Colors.white,
                    child: const Text("Type"),
                  ),
                  const SizedBox(width: 6),
                  MaterialButton(
                    onPressed: () {
                      pressSearchByButton("", false, false, false);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.white,
                    child: const Text("Clear"),
                  ),
                ],
              ),
            ),

            // StreamBuilder to display filtered results
            StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                }

                // Filter the documents based on the search input
                final filteredDocs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final searchValue = controllerSearch.text.toLowerCase();

                  if (searchType == "name") {
                    return data['name']
                            ?.toString()
                            .toLowerCase()
                            .contains(searchValue) ??
                        false;
                  } else if (searchType == "city") {
                    return data['city']
                            ?.toString()
                            .toLowerCase()
                            .contains(searchValue) ??
                        false;
                  } else if (searchType == "type") {
                    return data['type']
                            ?.toString()
                            .toLowerCase()
                            .contains(searchValue) ??
                        false;
                  }
                  return true; // If no search type is selected, return all
                }).toList();

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    return PostingGridTileUi(
                      posting: PostingModel.fromFirestore(doc),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
