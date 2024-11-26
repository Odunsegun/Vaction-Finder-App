import 'package:flutter/material.dart';
import 'LoginPage.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController _phoneController = TextEditingController();

  // Function to show dialog for adding phone number
  void _showPhoneDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Phone Number'),
          content: TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Enter Phone Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save phone number functionality to be implemented
                print('Phone number saved: ${_phoneController.text}');
                Navigator.of(context).pop(); // Close the dialog after saving
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to show logout confirmation dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();

                // Reset the navigation stack and go to the LoginPage
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false, // Remove all routes from the stack
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Email: user@example.com'), // Replace with dynamic email
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showPhoneDialog, // Show the dialog when clicked
              child: Text('Add Number'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              readOnly: true, // Make the text field read-only, phone number is updated via dialog
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showLogoutDialog, // Show logout confirmation dialog
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
