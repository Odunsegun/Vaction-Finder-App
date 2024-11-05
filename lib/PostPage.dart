import 'package:flutter/material.dart';

class PostPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PostPage();

}

class _PostPage extends State<PostPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: Column(),
    );
  }

}