class Event
{
  int? id;
  String userEmail;
  String label;
  int pinId;
  String date;
  String time;

  Event({this.id,
    required this.userEmail,
    required this.pinId,
    required this.label,
    required this.date,
    required this.time});

  factory Event.fromMap(Map<String, dynamic> json)=>Event(
      id: json["id"] ,
      userEmail: json["userEmail"],
      pinId: json["pinId"],
      label:json["label"],
      date: json["date"],
      time:json["time"]);

  Map<String, dynamic> toMap()=>{
    "userEmail":userEmail,
    "pinId" : pinId,
    "label":label,
    "date": date,
    "time" : time,
  };
}