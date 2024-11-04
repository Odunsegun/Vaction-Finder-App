import 'package:flutter/material.dart';

import 'Map.dart';

class MapPage extends StatefulWidget{
  const MapPage({super.key});

  @override
  State<StatefulWidget> createState() => _MapPage();
}

class _MapPage extends State<MapPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            // clipBehavior: Clip.hardEdge,
            children: <Widget>[
              Container(height: MediaQuery.sizeOf(context).height-100,child: Map(),),
              Container(padding:EdgeInsets.only(top:25),height:100, child:SearchBar()),
              // Map()
              ]
          ),
          Container(height: 100,color: Colors.grey,)
        ],
      ),
    );
  }

}