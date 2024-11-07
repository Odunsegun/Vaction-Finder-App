import 'package:flutter/material.dart';
import 'package:final_project/post/PostPage.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'Map.dart';
import 'package:google_places_flutter/google_places_flutter.dart';


class MapPage extends StatefulWidget{
  const MapPage({super.key});

  @override
  State<StatefulWidget> createState() => _MapPage();
}

class _MapPage extends State<MapPage>{
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            // clipBehavior: Clip.hardEdge,
            children: <Widget>[
              Container(height: MediaQuery.sizeOf(context).height-100,child: Map(),),
              Container(padding:EdgeInsets.only(top:100,left: 10,right: 10),
                  child: GooglePlaceAutoCompleteTextField(
                    inputDecoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                    ),
                    boxDecoration: BoxDecoration(
                        color: Colors.white60,
                        border: Border.all(width: 5,color: Colors.grey)
                    ),
                    textEditingController: controller,
                    googleAPIKey: "AIzaSyCS61S7nUwtNxf9elJwRJrA_hYsS_C42lM",
                    countries: ['ca'],
                    itemClick: (Prediction prediction){
                      controller.text = prediction.description!;
                      print(prediction.id);
                      print(prediction.lat);
                      print(prediction.lng);
                    },
                  )
              ),
              // Map()
              ]
          ),
          Container(height: 100,color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> PostPage())
                  );
                }, child: Icon(Icons.view_day), heroTag: 'postTag',),
                FloatingActionButton(onPressed: (){
                }, child: Icon(Icons.person), heroTag: 'accountTag',),
              ],
            )
          )
        ],
      ),
    );
  }

}