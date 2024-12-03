import 'package:final_project/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'Sqflite.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _email;
  String? _phone;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load data from SQLite on initialization
  }

  // Fetch data from the database
  Future<void> _loadUserData() async {
    final userData = await DatabaseHelper().getUserData();
    setState(() {
      _email = userData != null?['email']:
      _phone = userData?['phone'];
    });
  }

  // Function to show dialog for editing email
  void _showEmailDialog() {
    _emailController.text = _email ?? '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(FlutterI18n.translate(context, "Email")),
          content: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: FlutterI18n.translate(context, "Email"),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(FlutterI18n.translate(context, "Cancel")),
            ),
            TextButton(
              onPressed: () async {
                // Save the updated email
                await DatabaseHelper().updateUserData(_emailController.text, _phone ?? '');
                setState(() {
                  _email = _emailController.text; // Update UI
                });
                Navigator.of(context).pop();
              },
              child: Text(FlutterI18n.translate(context, "Save")),
            ),
          ],
        );
      },
    );
  }

  // Function to show dialog for editing phone number

  void _showPhoneDialog() {
    _phoneController.text = _phone ?? ''; // Pre-fill with existing number
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(FlutterI18n.translate(context, "Phone Number")),
          content: TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: FlutterI18n.translate(context, "Phone Number"),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number, // Numeric keyboard
            inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Restrict input to numbers
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(FlutterI18n.translate(context, "Cancel")),
            ),
            TextButton(
              onPressed: () async {
                final newPhone = _phoneController.text;
                if (newPhone.isEmpty) {
                  // Show error if no input
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(FlutterI18n.translate(context, "Only enter numbers")),
                    ),
                  );
                  return;
                }
                // Save the updated phone number
                await DatabaseHelper().updateUserData(_email ?? '', newPhone);
                setState(() {
                  _phone = newPhone; // Update UI
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(FlutterI18n.translate(context, "Save")),
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
          title: Text(FlutterI18n.translate(context, "Logout")),
          content: Text(FlutterI18n.translate(context, "Confirm you want to log out")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(FlutterI18n.translate(context, "Cancel")),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()), // Redirect to LoginPage
                      (route) => false, // Remove all routes from stack
                );
              },
              child: Text(FlutterI18n.translate(context, "Logout")),
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
            ElevatedButton(
              onPressed: _showEmailDialog, // Show the dialog when clicked
              child: Text(FlutterI18n.translate(context, "Email")),
            ),
            if (_email != null) // Display email if available
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text('${FlutterI18n.translate(context, "Email")}: $_email'),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showPhoneDialog,
              child: Text(FlutterI18n.translate(context, "Phone Number")),
            ),
            if (_phone != null) // Display phone number if available
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text('${FlutterI18n.translate(context, "Phone Number")}: $_phone'),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showLogoutDialog, // Show logout confirmation dialog
              child: Text(FlutterI18n.translate(context, "Logout")),
            ),
            SizedBox(height: 30),
            // Language Switcher Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _changeLanguage('en'), // Switch to English
                  child: Text("English"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _changeLanguage('fr'), // Switch to French
                  child: Text("Français"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<void> saveLanguagePreference(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('preferred_language', languageCode);
  }


  Future<String?> loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('preferred_language');
  }
  Future<void> _changeLanguage(String languageCode) async {
    await saveLanguagePreference(languageCode);
    await FlutterI18n.refresh(context, Locale(languageCode)); // Change the language
    setState(() {});
  }
}
