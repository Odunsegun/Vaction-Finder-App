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
}