class Location{
  String name;
  double latitude;
  double longitude;

  Location(this.name,this.latitude,this.longitude);

  Map<String,dynamic> toMap(){
    return {
      "name": name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) { //for 
    return Location(
      map['name'],
      map['latitude'],
      map['longitude'],
    );
  }
}