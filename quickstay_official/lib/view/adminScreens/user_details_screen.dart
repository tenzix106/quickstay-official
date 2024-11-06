import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userID;
  final String firstName;
  final String lastName;
  final String email;
  final ImageProvider image;

  UserDetailsScreen({
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
  });

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _email;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _firstName = widget.firstName;
    _lastName = widget.lastName;
    _email = widget.email;
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Update the user information in Firestore
        await FirebaseFirestore.instance.collection('users').doc(widget.userID).update({
          'firstName': _firstName,
          'lastName': _lastName,
          'email': _email,
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User  information updated successfully!')));
      } catch (e) {
        // Handle errors (e.g., network issues)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update user information: $e')));
      }

      // After saving, toggle back to view mode
      _toggleEdit();
    }
  }

  Future<void> _deleteUser () async {
    // Show a confirmation dialog
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this user? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        // Delete the user from Firestore
        await FirebaseFirestore.instance.collection('users').doc(widget.userID).delete();

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User  deleted successfully!')));

        // Navigate back or close the screen after deletion
        Navigator.of(context).pop();
      } catch (e) {
        // Handle errors (e.g., network issues)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete user: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_isEditing ? "Edit" : "View"} User'),
        backgroundColor: Color.fromRGBO(76, 215, 208, 100),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _isEditing ? _saveChanges : _toggleEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteUser ,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: widget.image,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: _firstName,
                decoration: InputDecoration(labelText: 'First Name'),
                enabled: _isEditing,
                onSaved: (value) {
                  _firstName = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: _lastName,
                decoration: InputDecoration(labelText: 'Last Name'),
                enabled: _isEditing,
                onSaved: (value) {
                  _lastName = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: 'Email'),
                enabled: _isEditing,
                onSaved: (value) {
                  _email = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}