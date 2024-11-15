import 'package:flutter/material.dart';
import 'Post.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  PostWidget({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('User: ${post.userID}'),
          Text('Location: ${post.location.name}'),
          Text('Description: ${post.description}'),
          Divider(height: 15, thickness: 1, color: Colors.black38),
        ],
      ),
    );
  }
}
