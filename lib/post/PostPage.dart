import 'package:final_project/post/PostWidget.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PostPage();

}

class _PostPage extends State<PostPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 2,
          itemBuilder: (BuildContext context, int index){
            return PostWidget();
          }
      ),
    );
  }

}