import 'package:cloud_firestore/cloud_firestore.dart';

class Account{
  late String username;
  late String password;
  List<dynamic> places = [];
  DocumentReference? reference;

  Account(this.username,this.password){
   // places = [];
  }

  Map<String, dynamic> toMap(){
    return {
      'username':username,
      'password':password,
      'places':places,
    };
  }

  Account.fromMap(Map<String,dynamic> map, DocumentReference ref){
    username = map['username'];
    password = map['password'];
    places = map['places'];
    reference = ref;
  }
}