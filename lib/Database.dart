import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post/Post.dart';


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
}