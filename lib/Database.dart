import 'package:final_project/Account.dart';
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

  Future<Account?> getUser(String username, String password) async{
    var snapshots = await database.collection("users").where('username',isEqualTo: username).get();
    for(var doc in snapshots.docs){
      if(doc.get('password') != password){
        return null;
      }
      else {
        print(doc.data());
        if(doc.data() == null){return null;}
        return Account.fromMap(doc.data());
        // return Account("email", "password");
        // return Account.fromMap(doc.data());
      }
    }
    return null;
  }

  Future<void> insertUser(String username, String password) async{
    await database.collection('users').add(
      {
        'username': username,
        'password': password,
      }
    );
  }
  Future<bool> registerUser(String username, String password) async{
    var snapshots = await database.collection('users').where('username', isEqualTo: username).get();
    if(snapshots.size != 0){
      return false;
    }
    else {
      insertUser(username, password);
      return true;
    }
  }
}