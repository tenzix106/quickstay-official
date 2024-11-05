import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickstay_official/global.dart';
import 'package:quickstay_official/model/conversation_model.dart';
import 'package:quickstay_official/view/conversation_screen.dart';
import 'package:quickstay_official/widgets/conversation_list_tile_ui.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: inboxViewModel.getConversations(),
      builder: (context, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: dataSnapshot.data!.docs.length,
            itemExtent: MediaQuery.of(context).size.height / 9,
            itemBuilder: (context, index) {
              DocumentSnapshot snapshot = dataSnapshot.data!.docs[index];

              ConversationModel currentConversation = ConversationModel();
              currentConversation.getConversationInforFromFirestore(snapshot);

              return InkResponse(
                onTap: () {
                  Get.to(() => ConversationScreen(
                        conversation: currentConversation,
                      ));
                },
                child: ConversationListTileUI(
                  conversation: currentConversation,
                ),
              );
            },
          );
        }
      },
    );
  }
}
