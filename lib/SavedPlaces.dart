import 'package:flutter/material.dart';
import 'Database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedPlacesPage extends StatefulWidget {
  String user;
  SavedPlacesPage(this.user,{super.key});

  @override
  State<StatefulWidget> createState() => _SavedPlacesPage();

}

class _SavedPlacesPage extends State<SavedPlacesPage>{
   List<String> savedPlaces = [];

  Future<void> savePlace(String placeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedPlaces.add(placeId);
    prefs.setStringList('savedPlaces', savedPlaces);

    //database.addBookmark(widget.user, placeId); <-- to sync with Firestore
  }

  Future<void> loadSavedPlaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedPlaces = prefs.getStringList('savedPlaces') ?? [];
  }

  @override
  void initState() {
    super.initState();
    loadSavedPlaces(); 
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: savedPlaces.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(savedPlaces[index]),
        );
      },
    );
  }
}
