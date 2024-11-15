import 'package:flutter/material.dart';

class PostWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PostWidget();

}

class _PostWidget extends State<PostWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: const Column(
        children: [
          Text("userID"),
          Text("locationName"),
          Text("description"),
          Divider(height: 15,thickness: 10,color: Colors.black38,),
        ],
      ),
    );
  }
}