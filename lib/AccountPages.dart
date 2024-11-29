import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController _phoneController = TextEditingController();

  //local storage
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

  // Function to show dialog for adding phone number
  void _showPhoneDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(FlutterI18n.translate(context, "account.add_number")),
          content: TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: FlutterI18n.translate(context, "account.phone_number"),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(FlutterI18n.translate(context, "button_label.cancel")),
            ),
            TextButton(
              onPressed: () {
                // Save phone number functionality to be implemented
                print('Phone number saved: ${_phoneController.text}');
                Navigator.of(context).pop(); // Close the dialog after saving
              },
              child: Text(FlutterI18n.translate(context, "button_label.save")),
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
          title: Text(FlutterI18n.translate(context, "account.logout")),
          content: Text(FlutterI18n.translate(context, "account.logout_confirmation")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(FlutterI18n.translate(context, "button_label.cancel")),
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
              child: Text(FlutterI18n.translate(context, "button_label.logout")),
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
            Text('${FlutterI18n.translate(context, "account.email")} user@example.com'), // Replace with dynamic email
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showPhoneDialog, // Show the dialog when clicked
              child: Text(FlutterI18n.translate(context, "account.add_number")),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: FlutterI18n.translate(context, "account.phone_number"),
                border: OutlineInputBorder(),
              ),
              readOnly: true, // Make the text field read-only, phone number is updated via dialog
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showLogoutDialog, // Show logout confirmation dialog
              child: Text(FlutterI18n.translate(context, "account.logout")),
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
}
