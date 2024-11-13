import 'package:flutter/material.dart';

class SavedPlacesPage extends StatefulWidget {
  String user;
  SavedPlacesPage(this.user,{super.key});

  @override
  State<StatefulWidget> createState() => _SavedPlacesPage();

}

class _SavedPlacesPage extends State<SavedPlacesPage>{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Saved places will appear here'),
    );
  }
}
