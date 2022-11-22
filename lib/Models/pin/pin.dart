class Pin
{
  int? id;
  String userEmail;
  num longitude;
  num latitude;
  String label;
  String? description;
  bool isFavorite;

      Pin({this.id,
        required this.userEmail,
        this.description = '',
     required this.longitude,
     required this.latitude,
     required this.label,
     required this.isFavorite});

      factory Pin.fromMap(Map<String, dynamic> json)=>Pin(
          id: json["id"] ,
          userEmail: json["userEmail"],
          description: json["description"],
          longitude:json["longitude"],
          latitude:json["latitude"],
          label:json["label"],
          isFavorite:  json["isFavorite"] == 1? true:false);

      Map<String, dynamic> toMap()=>{
        "userEmail":userEmail,
        "longitude":longitude,
        "latitude":latitude,
        "label":label,
        "description":description,
        "isFavorite":isFavorite ? 1:0
      };
}
