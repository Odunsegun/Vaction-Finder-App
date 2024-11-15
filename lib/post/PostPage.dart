import 'package:final_project/post/PostWidget.dart';
import 'package:flutter/material.dart';
import 'Post.dart';
import 'PostFormPage.dart';
import 'package:final_project/Database.dart';

class PostPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PostPage();

}

class _PostPage extends State<PostPage>{
   final Database database = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Posts")),
      body: FutureBuilder<List<Post>>(
        future: database.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No posts available."));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Post post = snapshot.data![index];
                return ListTile(
                  title: Text(post.description ?? "No description"),
                  subtitle: Text("Location: ${post.location.name}"),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostFormPage(
                            postId: snapshot.data![index].id, // Pass the Firestore document ID
                            post: post,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostFormPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
  /*
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
  }*/

  

}