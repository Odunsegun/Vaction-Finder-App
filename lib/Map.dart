import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class Map extends StatefulWidget{
  const Map({super.key});

  @override
  State<StatefulWidget> createState() => _Map();
}

class _Map extends State<Map>{
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(43.94529387752341, -78.89694830522029),
            initialZoom: 18.5,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            RichAttributionWidget( // Include a stylish prebuilt attribution widget that meets all requirments
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')), // (external)
                ),
              ],
            ),
          ],
        );
  }

}