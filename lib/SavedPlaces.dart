import 'dart:convert';

import 'package:flutter/material.dart';
import 'Database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:http/http.dart';

class SavedPlacesPage extends StatefulWidget {
  String user;
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
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // savedPlaces = prefs.getStringList('savedPlaces') ?? [];
    savedPlaces = (await database.getSavedLocations(widget.user))!;
    var url = 'maps.googleapis.com';
    List<(String,dynamic)> result = [];
    int i = 0;
    for(var item in savedPlaces){
      if(item != ""){
        String it = item.toString();
        // Uri uri = Uri.https(url,'maps/api/place/details/json?fields=name&place_id=$it&key=AIzaSyCu_L7YZRnt4IWMurIRZnIijJJF3nfv6Wc');
        // Uri uri = Uri.https(url, 'maps/api/place/details/json');
        String str = 'https://maps.googleapis.com/maps/api/place/details/json?fields=name&place_id=$it&key=AIzaSyCu_L7YZRnt4IWMurIRZnIijJJF3nfv6Wc';
        // Uri uri = Uri.https(Uri.parse(str));
        // result.add(await get(Uri.parse(str)));
        final response = await get(Uri.parse(str));
        Map<String,dynamic> json = jsonDecode(response.body);
        // print(json['result']['name']);
        result.add((savedPlaces[i],json['result']['name']));
        i++;
      }
    }
    savedPlaces = result;
    setState(() {

    });
  }



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      loadSavedPlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: savedPlaces.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Row(
            children: [
              Text(savedPlaces[index].$2),
              // TextButton(onPressed: onPressed, child: Text("Navigate"))
            ],
          ),
        );
      },
    );
  }
  //  @override
  //  Widget build(BuildContext context) {
  //    return FutureBuilder(
  //       future: database.getSavedLocations(widget.user), builder: (context,snapshot){
  //         if(snapshot.connectionState == ConnectionState.done){
  //           print("snap = ${snapshot}");
  //           return ListView.builder(itemCount: snapshot.data?.length, itemBuilder: (context,index){
  //             return Text(snapshot.toString());
  //           },);
  //         }
  //         else{
  //           return CircularProgressIndicator();
  //         }
  //    },
  //    );
  //  }
  //  @override
  //  Widget build(BuildContext context) {
  //    return FutureBuilder(
  //      future: database.getUserNoPass(widget.user), builder: (context,snapshot){
  //      // print("snap = ${snapshot}");
  //      print("RETURNED NULL");
  //      if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
  //        // List<String>? list = snapshot.data;
  //        print("TEST");
  //        return ListView.builder(itemCount: snapshot.data?.places.length, itemBuilder: (context,index){
  //
  //          print(Uri.https("https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJF7QkuDsDLz4R0rJ4SsxFl9w&key=AIzaSyCu_L7YZRnt4IWMurIRZnIijJJF3nfv6Wc)"));
  //          return Text(snapshot.data?.places[index]);
  //        },);
  //      }
  //      else{
  //        return CircularProgressIndicator();
  //      }
  //    },
  //    );}
  // @override
  // Widget build(BuildContext context){
  //   return Lis
  // }



}
