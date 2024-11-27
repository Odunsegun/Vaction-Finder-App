import 'package:final_project/Database.dart';
import 'package:flutter/material.dart';
import 'package:final_project/post/PostPage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:latlong2/latlong.dart';
import '../Account.dart';
import 'Map.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:location/location.dart' as deviceLocation;
import 'package:final_project/map/Location.dart';


class MapPage extends StatefulWidget{
  Account user;
  MapPage(this.user, {super.key});


  @override
  State<StatefulWidget> createState() => _MapPage();
}

class _MapPage extends State<MapPage>{
  TextEditingController controller = TextEditingController();
  late MapController mapController;
  String? currentLoc;
  double? currentLat;
  double? currentLng;
  String? currentPlaceID = "";
  double deviceLat = 43.94529387752341;
  double deviceLong = -78.89694830522029;
  late Map map;
  (double,double,double,double)? path;

  Database database = Database();

  List<Marker> recommendedLocationMarkers = [];//list of location markers

  Future<void> fetchAndDisplayRecommendedLocations(String type) async {
    List<Location> locations = await database.getRecommendedLocations(type);
    setState(() {
      recommendedLocationMarkers = locations.map((location) {
        return Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(location.latitude, location.longitude),
          child: Icon(Icons.location_pin, color: Colors.red, size: 40),
        );
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    fetchAndDisplayRecommendedLocations("landmark"); //"landmark" would basically be the detour    print("path = $path >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    map = Map(mapController, curLat: deviceLat, curLong: deviceLong,path: path,);
  }

  Future<Position> getCurrentPosition() async{
    bool serviceEnabled;
    LocationPermission locationPermission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print("service = $serviceEnabled\n");
    if(!serviceEnabled){
      return Future.error('Location services disabled.');
    }
    locationPermission = await Geolocator.checkPermission();
    print("locPERM = $locationPermission\n");
    if(locationPermission == LocationPermission.denied){
      locationPermission = await Geolocator.requestPermission();
      if(locationPermission == LocationPermission.denied){
        return Future.error('Location permissions are denied');
      }
    }
    if(locationPermission == LocationPermission.deniedForever){
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            // clipBehavior: Clip.hardEdge,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.sizeOf(context).height-60,
                child: map,
//map
              ),
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.sizeOf(context).height-225,
                  left: MediaQuery.sizeOf(context).width-75
                ),
                child:IconButton(onPressed: () {
                  if(currentPlaceID!.isNotEmpty){
                    print('Bookmarked...................');
                    
                    widget.user.places.add(currentPlaceID!);
                    database.addBookmark(widget.user);
                  }
                  else{
                    print('NOT BOOKMARKED..................');
                    showDialog(context: context, builder: (context)=>
                      AlertDialog(
                        title: const Text("Select location first."),
                        actions: [
                          TextButton(onPressed: ()=>Navigator.of(context).pop(),
                              child: const Text("OK"))
                        ],
                      )
                    );
                  }
                },
              icon:Icon(Icons.bookmark_border, size: 40),)
              ),
              Container(
                padding: EdgeInsets.only(top:MediaQuery.sizeOf(context).height-175,left: 10),
                  // color: Color.fromARGB(150, 1, 1, 1),
                  // width: 1000,
                  // height: 10,
                child: Container(
                 
                  child: Column(
                    children: [
                      Text('Current Location:',style: TextStyle(fontSize: 18)),
                      Text('${currentLoc}',style: TextStyle(fontSize: 18)),
                      Text('Latitude:${currentLat}, Longitude:${currentLng}',style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  color: Color.fromARGB(150, 10, 10, 10),
                  width: MediaQuery.sizeOf(context).width-20,
                ),
              ),
              Container(
                padding:EdgeInsets.only(
                  top:65, left: 10, right: 10
                  ),
                  child: GooglePlaceAutoCompleteTextField(
                    isLatLngRequired: true,
                    inputDecoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                    ),
                    boxDecoration: BoxDecoration(
                        color: Colors.white60,
                        border: Border.all(width: 5,color: Colors.grey)
                    ),
                    textEditingController: controller,
                    googleAPIKey: "AIzaSyCu_L7YZRnt4IWMurIRZnIijJJF3nfv6Wc",
                    countries: ['ca'],
                    getPlaceDetailWithLatLng: (Prediction prediction){
                      print('lat=${prediction.lat}, lng=${prediction.lng}');
                      print("${prediction.placeId}");
                      setState(() {
                        currentLat = double.parse(prediction.lat!);
                        currentLng = double.parse(prediction.lng!);
                        // map.setLatLng(currentLat!, currentLng!);
                        // map.camera.move(LatLng(currentLat!, currentLng!),18.5);
                        mapController.move(LatLng(currentLat!, currentLng!),18.5);
                      });

                    },
                    itemClick: (Prediction prediction){
                      setState(() {
                        controller.text = prediction.description!;
                        currentLoc = prediction.description;
                        currentPlaceID = prediction.placeId!;
                      });
                      // print(prediction.placeId);
                      // print(prediction.lat);
                      // print(prediction.lng.toString());
                    },
                    placeType: PlaceType.geocode,
                  )
              ),
              Container(
                padding: EdgeInsets.only(top:MediaQuery.sizeOf(context).height-220),
                child:IconButton(
                  onPressed: () async{
                    Position pos = await getCurrentPosition();
                      if(currentLat!= null && currentLng!=null){
                        double lat = currentLat!;
                        double lng = currentLng!;
                        setState(() {
                          map = Map(mapController,curLat: lat,curLong: lng,path: (pos.latitude,pos.longitude,lat,lng));
                        });
                      }},
                  icon: const Icon(Icons.assistant_direction,size: 30,),),),
              Container(
                padding: EdgeInsets.only(top:MediaQuery.sizeOf(context).height-265),
                child:IconButton(
                  onPressed: () async {
                    Position pos = await getCurrentPosition();
                    setState(() {
                      mapController.move(LatLng(pos.latitude,pos.longitude), 18.5);
                      print("LAT = $deviceLat, LONG = $deviceLong");
                    });
                  },
                  icon: const Icon(Icons.my_location,size: 30,),),),
              ]
          ),
        ],
      ),
    );
  }
}