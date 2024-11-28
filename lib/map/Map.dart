
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as FlutterMap;
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart' as prefix;
import 'package:latlong2/latlong.dart' as Lat;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_directions/google_maps_directions.dart' as Google;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'l'
class Map extends StatefulWidget{
  FlutterMap.MapController camera;
  double curLat;
  double curLong;
  (double,double,double,double)? path;
  Function onLocChange;

  Map(this.camera, this.onLocChange,{this.curLat = 43.94529387752341, this.curLong=-78.89694830522029, this.path, super.key}){
    // camera = FlutterMap.MapController();
    Google.GoogleMapsDirections.init(googleAPIKey: "AIzaSyCS61S7nUwtNxf9elJwRJrA_hYsS_C42lM");
  }
  // Future<FlutterMap.PolylineLayer> getPolylineLayer() async{
  //
  // }
  @override
  State<StatefulWidget> createState() => _Map();
}

class _Map extends State<Map>{
  late double curLong;
  late double curLat;
  (double,double,double,double)? path;
  FlutterMap.LayerHitNotifier hitNotifier = ValueNotifier(null);
  bool? showMarker;
  Lat.LatLng? markerLoc;

  @override
  void initState(){
    super.initState();
    curLong = widget.curLong;
    curLat = widget.curLat;
    path = widget.path;
    print("path = $path >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
  }

  Future<List<FlutterMap.Polyline>> getPath(double p1Lat,double p1Long,double p2Lat,double p2Long) async{
    Google.Directions directions = await Google.getDirections(p1Lat, p1Long, p2Lat, p2Long);
    Google.DirectionRoute route = directions.shortestRoute;
    List<Lat.LatLng> points = PolylinePoints().decodePolyline(route.overviewPolyline.points).map(
        (point) => Lat.LatLng(point.latitude, point.longitude)).toList();
    List<FlutterMap.Polyline> polylines = [
      FlutterMap.Polyline(
        borderColor: Colors.red,
        points:points,
        color: Colors.blue,
        borderStrokeWidth: 5
      )
    ];
    setState(() {

    });
    return polylines;
  }


  Future<Position> getCurrentPosition() async{
    bool serviceEnabled;
    LocationPermission locationPermission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error('Location services disabled.');
    }
    locationPermission = await Geolocator.checkPermission();
    if(locationPermission == LocationPermission.denied){
      locationPermission = await Geolocator.requestPermission();
      if(locationPermission == LocationPermission.denied){
        return Future.error('Location permissions are denied');
      }
    }
    if(locationPermission == LocationPermission.deniedForever){
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  // Future<FlutterMap.PolylineLayer> getPolylineLayer() async{
  //
  // }

  @override
  Widget build(BuildContext context) {
    print("path = $path >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    return FlutterMap.FlutterMap(
          options: FlutterMap.MapOptions(
            initialCenter: Lat.LatLng(curLat, curLong),
            initialZoom: 18.5,
            onMapEvent: (event){
              if(event is FlutterMap.MapEventTap){
                print("POS = ${event.tapPosition}");
                widget.onLocChange(event.tapPosition.latitude,event.tapPosition.longitude);
                showMarker = true;
                markerLoc = event.tapPosition;
                setState(() {

                });
              }
            },
          ),
          mapController: widget.camera,
          // options: FlutterMap.MapOptions(onMapReady: (){
          //   widget.camera.mapEventStream.listen((evt){print(evt.toString());});
          // }),
          children: [
            FlutterMap.TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            FlutterMap.RichAttributionWidget( // Include a stylish prebuilt attribution widget that meets all requirments
              attributions: [
                FlutterMap.TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')), // (external)
                ),
              ],
            ),
            if(path!=null) FutureBuilder(future: getPath(path!.$1, path!.$2,path!.$3,path!.$4), builder: (context,snapshot){
              print("BUILD");
              if(snapshot.data != null) {
                return FlutterMap.PolylineLayer(
                  polylines: snapshot.data!
                );
              }
              else{
                return const SizedBox.shrink();
              }
            }),
            if(showMarker == true) FlutterMap.MarkerLayer(
                markers: [
                  FlutterMap.Marker(point: markerLoc!, child: Icon(Icons.place, size: 40,))
                ]
            ),
            // if(path != null) FlutterMap.PolylineLayer(
            //   polylines: await getPath(curLat, curLong, path!.$1, path!.$1),
            // )
          ],
        );
  }

}
