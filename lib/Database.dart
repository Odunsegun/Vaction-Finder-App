import 'package:final_project/Account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post/Post.dart';
import 'package:location/location.dart' as deviceLocation;
import 'package:final_project/map/Location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


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
  Future<Account?> getUserNoPass(String username) async{
    var snapshots = await database.collection("users").where('username',isEqualTo: username).get();
    for(var doc in snapshots.docs){
      print(doc.data());
      if(doc.data() == null){return null;}
      return Account.fromMap(doc.data(), doc.reference);
      // return Account("email", "password");
      // return Account.fromMap(doc.data());
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

  Future<List<dynamic>?> getSavedLocations(String user) async {
    var snapshots = await database.collection('users').where('username', isEqualTo: user).get();
    // print("snapshots = ${snapshots.size}");
    for (var doc in snapshots.docs){
      // print("${doc.get('places')}");
      // for(var str in doc.get('places')){
      //   print(str);
      // }
      print(doc.get('places'));
      // print(doc.get('places') as List<String>);
      List<dynamic> result = doc.get('places');
      print("test $result");
      // print(type)
      return result;
    }
    print("RETURNED NULL");
    return null;
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
  Future<List<Post>> fetchPosts({int limit = 10, int offset = 0}) async {
    try {
        var response = await http.get(
            Uri.parse('https://mobile-final-c33c5.cloudfunctions.net/api?limit=$limit&offset=$offset')
        );
        if (response.statusCode == 200) {
            return (jsonDecode(response.body) as List)
                .map((item) => Post.fromMap(item))
                .toList();
        } else {
            throw Exception('Failed to fetch posts: ${response.statusCode}');
        }
    } catch (e) {
        print(e);
        throw Exception('Network error: Unable to fetch posts');
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

  Future<void> cachePosts(List<Post> posts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cachedPosts', jsonEncode(posts.map((e) => e.toMap()).toList()));
  }

  Future<List<Post>> getCachedPosts() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? data = prefs.getString('cachedPosts');
      if (data != null) {
          return (jsonDecode(data) as List)
              .map((item) => Post.fromMap(item))
              .toList();
      }
      return [];
  }
}
