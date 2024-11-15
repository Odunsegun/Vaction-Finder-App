import 'package:final_project/Account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post/Post.dart';
import 'package:location/location.dart' as deviceLocation;
import 'package:final_project/map/Location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Database{
  late FirebaseFirestore database;

  Database(){
    database = FirebaseFirestore.instance;
  }

  Future<QuerySnapshot> getCollection(String collection)async {
    return await database.collection(collection).get();
  }
  Future<void> insertItem(String collection,dynamic item)async{
    database.collection(collection).add(item.toMap());
  }

  Future<Account?> getUser(String username, String password) async{
    var snapshots = await database.collection("users").where('username',isEqualTo: username).get();
    for(var doc in snapshots.docs){
      if(doc.get('password') != password){
        return null;
      }
      else {
        print(doc.data());
        if(doc.data() == null){return null;}
        return Account.fromMap(doc.data(), doc.reference);
        // return Account("email", "password");
        // return Account.fromMap(doc.data());
      }
    }
    return null;
  }

  Future<void> insertUser(Account acc) async{
    await database.collection('users').add(
        acc.toMap()
    );
  }
  Future<bool> registerUser(Account acc) async{
    var snapshots = await database.collection('users').where('username', isEqualTo: acc.username).get();
    if(snapshots.size != 0){
      return false;
    }
    else {
      insertUser(acc);
      return true;
    }
  }
  Future<void> addBookmark(Account account) async{
    // print("${reference.get()}");
    await account.reference?.update(account.toMap());
  }

  Future<List<Location>> getRecommendedLocations(String type) async {
    var snapshots = await database.collection('locations')
        .where('type', isEqualTo: type)
        .get();
    return snapshots.docs.map((doc) => Location.fromMap(doc.data())).toList();
  }

  Future<List<Post>> getPosts() async {
    var snapshots = await database.collection('posts').get();
    return snapshots.docs.map((doc) => Post.fromMap(doc.data(), doc.id)).toList();
  }

  //add, delete and edit posts in firestore
/*  Future<void> addPost(Post post) async {
    await database.collection('posts').add(post.toMap());
  }

  Future<void> updatePost(String postId, Map<String, dynamic> updatedData) async {
    await database.collection('posts').doc(postId).update(updatedData);
  }

  Future<void> deletePost(String postId) async {
    await database.collection('posts').doc(postId).delete();
  }
  */
    // Fetch posts from an API
  Future<List<Post>> fetchPosts() async {
    var response = await http.get(Uri.parse('https://mobile-final-c33c5.cloudfunctions.net/api'));//link to our firebase project
    if (response.statusCode == 200) {
      List postItems = jsonDecode(response.body);
      return postItems.map((item) => Post.fromMap(item)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Add a post to the API
  Future<void> addPost(Post post) async {
    var response = await http.post(
      Uri.parse('https://mobile-final-c33c5.cloudfunctions.net/api'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(post.toMap()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add post');
    }
  }

  // Update a post in the API
  Future<void> updatePost(String id, Post post) async {
    var response = await http.put(
      Uri.parse('https://mobile-final-c33c5.cloudfunctions.net/api'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(post.toMap()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update post');
    }
  }

  // Delete a post in the API
  Future<void> deletePost(String id) async {
    var response = await http.delete(Uri.parse('https://mobile-final-c33c5.cloudfunctions.net/api'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }
  }
}
