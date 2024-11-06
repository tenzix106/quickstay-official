import 'package:flutter/material.dart';
import 'package:quickstay_official/model/app_constants.dart';

class PersonalInformatioScreen extends StatelessWidget {
  const PersonalInformatioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(76, 215, 208, 100),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Picture
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AppConstants.currentUser .displayImage,
                  backgroundColor: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 20),

              // User's Full Name
              _buildInfoCard(
                title: 'Full Name',
                value: AppConstants.currentUser .getFullNameOfUser (),
              ),
              const SizedBox(height: 10),

              // User's Email
              _buildInfoCard(
                title: 'Email',
                value: AppConstants.currentUser.email.toString(),
              ),
              const SizedBox(height: 10),

              // User's Bio
              _buildInfoCard(
                title: 'Bio',
                value: AppConstants.currentUser .bio ?? 'Not provided',
              ),
              const SizedBox(height: 10),

              // User's Location
              _buildInfoCard(
                title: 'Location',
                value: AppConstants.currentUser .getLocationOfUser (),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color.fromRGBO(76, 215, 208, 0.2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}