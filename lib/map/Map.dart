import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as FlutterMap;
import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart' as prefix;
import 'package:latlong2/latlong.dart' as Lat;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_directions/google_maps_directions.dart' as Google;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'l'
class Map extends StatefulWidget{
  FlutterMap.MapController camera;
  Map(this.camera, {super.key}){
    // camera = FlutterMap.MapController();
    Google.GoogleMapsDirections.init(googleAPIKey: "AIzaSyCS61S7nUwtNxf9elJwRJrA_hYsS_C42lM");
  }
  @override
  State<StatefulWidget> createState() => _Map();
}

class _Map extends State<Map>{
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
    return polylines;
  }
  @override
  Widget build(BuildContext context) {
    return FlutterMap.FlutterMap(
          options: const FlutterMap.MapOptions(
            initialCenter: Lat.LatLng(43.94529387752341, -78.89694830522029),
            initialZoom: 18.5,
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
            // FutureBuilder(futus
          ],
        );
  }

}
