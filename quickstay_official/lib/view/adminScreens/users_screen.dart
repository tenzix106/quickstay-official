import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:quickstay_official/view/adminScreens/user_details_screen.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UsersList(),
    );
  }
}

class UsersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No users found.'));
        }

        final users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final userData = user.data() as Map<String, dynamic>;
            final userID = user.id;

            return FutureBuilder<ImageProvider>(
              future: getImageFromStorage(userID),
              builder: (context, imageSnapshot) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      backgroundImage: imageSnapshot.connectionState == ConnectionState.done
                          ? imageSnapshot.data
                          : null,
                      child: imageSnapshot.connectionState == ConnectionState.waiting
                          ? CircularProgressIndicator()
                          : Text(
                              userData['firstName'] != null ? userData['firstName'][0] : '?',
                              style: TextStyle(color: Colors.white, fontSize: 24),
                            ),
                    ),
                    title: Text(
                      userData['firstName'] ?? 'Unnamed User',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(
                      userData['email'] ?? 'No email provided',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to UserDetailsScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsScreen(
                            userID: userID,
                            firstName: userData['firstName'] ?? 'N/A',
                            lastName: userData['lastName'] ?? 'N/A',
                            email: userData['email'] ?? 'N/A',
                            image: imageSnapshot.data ?? AssetImage('assets/images/avatar.png'), // Pass the ImageProvider
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<ImageProvider> getImageFromStorage(String userID) async {
    try {
      // Fetch the image from Firebase Storage
      final imageDataInBytes = await FirebaseStorage.instance
          .ref()
          .child("userImages")
          .child(userID)
          .child(userID + ".png")
          .getData(2048 * 2048);

      return MemoryImage(imageDataInBytes!);
    } catch (e) {
      // Handle errors (e.g., image not found)
      return AssetImage('assets/images/avatar.png'); // Provide a default image
    }
  }
}