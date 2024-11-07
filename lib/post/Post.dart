import '../map/Location.dart';

class Post{
  String? description;
  String userID;
  String? imageURL;
  Location location;


  Post(this.userID,this.location);

  Map<String,dynamic> toMap(){
    return {
      'userID':userID,
      'location':location.toMap(),
      'description':description,
      'imageURL': imageURL,
    };
  }
}