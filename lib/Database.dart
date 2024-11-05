import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Post.dart';


class Database{
  late FirebaseFirestore database;

  Database(){
    database = FirebaseFirestore.instance;
  }

  Future<void> insertPost(Post post)async {

  }


}