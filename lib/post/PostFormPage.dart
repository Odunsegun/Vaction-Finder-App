import 'package:flutter/material.dart';
import 'package:final_project/Database.dart';
import 'Post.dart';
import '../map/Location.dart';

class PostFormPage extends StatefulWidget {
  final String? postId; 
  final Post? post;     

  PostFormPage({this.postId, this.post});

  @override
  _PostFormPageState createState() => _PostFormPageState();
}
//edit and add posts
class _PostFormPageState extends State<PostFormPage> {
  final TextEditingController descriptionController = TextEditingController();
  final Database database = Database();

  @override
  void initState() {
    super.initState();
    
    if (widget.post != null) {
      descriptionController.text = widget.post!.description ?? "";
    }
  }

  Future<void> addPost(Post post) async {
    await database.addPost(post);
  }

  /*Future<void> updatePost(String postId, Map<String, dynamic> updatedData) async {
    await database.updatePost(postId, post);
  }*/
  Future<void> updatePost(Post post) async {
    await database.updatePost(post.id!, post);
  }

  Future<void> deletePost(String postId) async {
    await database.deletePost(postId);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.postId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Post" : "Add Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            // TextField(
            //   controller: ,
            //   decoration: InputDecoration(),
            // )
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (isEditing) {
                  // Create an updated Post object
                  Post updatedPost = Post(
                    userID: widget.post!.userID, 
                    location: widget.post!.location, 
                    description: descriptionController.text, 
                  );

                  // Call updatePost with the updated Post object
                  await updatePost(updatedPost);
                } else {
                  // Create a new post if adding
                  String userID = "UserID"; // Replace with actual user ID
                  Post newPost = Post(
                    userID: userID,
                    location: Location("Location", 43.0, -79.0),
                    description: descriptionController.text,
                  );

                  // Call addPost for the new post
                  await database.addPost(newPost);
                }

                Navigator.pop(context);
              },
              child: Text(isEditing ? "Update Post" : "Add Post"),
            ),

            if (isEditing) ...[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Confirm delete action
                  bool? confirmDelete = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Delete Post"),
                      content: Text("Are you sure you want to delete this post?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text("Delete"),
                        ),
                      ],
                    ),
                  );

                  // If confirmed, delete the post and go back
                  if (confirmDelete == true) {
                    await deletePost(widget.postId!);
                    if (context.mounted) Navigator.pop(context); 
                  }
                },
                style: ElevatedButton.styleFrom(iconColor: Colors.red),
                child: Text("Delete Post"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

