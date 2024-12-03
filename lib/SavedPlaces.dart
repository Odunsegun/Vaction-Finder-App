import 'dart:convert';

import 'package:final_project/Account.dart';
import 'package:final_project/HomePage.dart';
import 'package:flutter/material.dart';
import 'Database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:http/http.dart';

class SavedPlacesPage extends StatefulWidget {
  Account user;
  SavedPlacesPage(this.user,{super.key});

  @override
  State<StatefulWidget> createState() => _SavedPlacesPage();

}

class _SavedPlacesPage extends State<SavedPlacesPage>{
   List<dynamic> savedPlaces = [];
   Database database = Database();

  // Future<void> savePlace(String placeId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   savedPlaces.add(placeId);
  //   prefs.setStringList('savedPlaces', savedPlaces);
  //
  //   //database.addBookmark(widget.user, placeId); <-- to sync with Firestore
  // }

  Future<void> loadSavedPlaces() async {
    savedPlaces = (await database.getSavedLocations(widget.user.username))!;
    var url = 'maps.googleapis.com';
    List<(String,dynamic)> result = [];
    int i = 0;
    for(var item in savedPlaces){
      if(item != ""){
        String it = item.toString();
        String str = 'https://maps.googleapis.com/maps/api/place/details/json?fields=name&place_id=$it&key=AIzaSyCu_L7YZRnt4IWMurIRZnIijJJF3nfv6Wc';
        final response = await get(Uri.parse(str));
        Map<String,dynamic> json = jsonDecode(response.body);
        result.add((savedPlaces[i],json['result']['name']));
        i++;
      }
    }
    savedPlaces = result;
  }
   Future<(double,double)> getLocationsFromID(String id) async{
      String str = 'https://maps.googleapis.com/maps/api/place/details/json?'
          'fields=geometry'
          '&place_id=$id'
          '&key=AIzaSyCu_L7YZRnt4IWMurIRZnIijJJF3nfv6Wc';
      final response = await get(Uri.parse(str));
      Map<String,dynamic> json = jsonDecode(response.body);
      print(json['result']['geometry']['location']);
      return (json['result']['geometry']['location']['lat'] as double,
      json['result']['geometry']['location']['lng'] as double);
   }
  @override
  void initState() {
    super.initState();
  }
  @override
   Widget build(BuildContext context) {
     return FutureBuilder(future: loadSavedPlaces(),
         builder: (context,snapshot){
       if(snapshot.connectionState == ConnectionState.waiting){
         return CircularProgressIndicator();
       }
       else {
         return ListView.builder(
            itemCount: savedPlaces.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  children: [
                    Text(savedPlaces[index].$2),
                    TextButton(onPressed: () async {
                      (double,double) loc = await getLocationsFromID(savedPlaces[index].$1);
                      print("TEST loc = $loc");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>HomeScreen(widget.user, startLat: loc.$1,startLong: loc.$2))
                      );
                    }, child: Text("Navigate"))
                  ],
                ),
              );
            },
          );
       }
         });
   }
}
