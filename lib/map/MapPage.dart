import 'package:flutter/material.dart';
import 'package:final_project/post/PostPage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:latlong2/latlong.dart';
import 'Map.dart';
import 'package:google_places_flutter/google_places_flutter.dart';


class MapPage extends StatefulWidget{
  const MapPage({super.key});

  @override
  State<StatefulWidget> createState() => _MapPage();
}

class _MapPage extends State<MapPage>{
  TextEditingController controller = TextEditingController();
  late MapController mapController;
  String? currentLoc;
  double? currentLat;
  double? currentLng;
  late Map map;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }
  @override
  Widget build(BuildContext context) {
    map = Map(mapController);
    return Scaffold(
      body: Column(
        children: [
          Stack(
            // clipBehavior: Clip.hardEdge,
            children: <Widget>[
              SizedBox(height: MediaQuery.sizeOf(context).height-60,child: map,),
              Container(padding:EdgeInsets.only(top:MediaQuery.sizeOf(context).height-85,left: 10),
                child: Text("Latitude: $currentLat, Longitude: $currentLng", style: TextStyle(fontSize: 16),),
              ),
              Container(padding: EdgeInsets.only(top: 120,left: MediaQuery.sizeOf(context).width-75),child:IconButton(onPressed: () {
                print("${null}");
              },
              icon:Icon(Icons.bookmark_border, size: 40,))
              ),
              Container(padding:EdgeInsets.only(top:65,left: 10,right: 10),
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
                      });
                      // print(prediction.placeId);
                      // print(prediction.lat);
                      // print(prediction.lng.toString());
                    },
                    placeType: PlaceType.geocode,
                  )
              ),
              Container(
                color: Color.fromARGB(100, 1, 1, 1),
                width: 100,
                height: 100,
                padding: EdgeInsets.only(top:MediaQuery.sizeOf(context).height-100),
              )
              // Map()
              ]
          ),
        ],
      ),
    );
  }

}