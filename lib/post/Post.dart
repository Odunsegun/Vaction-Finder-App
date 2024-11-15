import '../map/Location.dart';

class Post{
  final String? id; //post id
  String? description;
  String userID;
  String? imageURL;
  Location location;


  //Post(this.userID,this.location);
  Post({
    this.id,
    required this.userID,
    required this.location,
    this.description,
    this.imageURL,
  });
  
  Map<String,dynamic> toMap(){
    return {
      'userID':userID,
      'location':location.toMap(),
      'description':description,
      'imageURL': imageURL,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map, [String? id]) {
    return Post(
      id: id,
      userID: map['userID'],
      location: Location.fromMap(map['location']),
      description: map['description'],
      imageURL: map['imageURL'],
    );
  }
}