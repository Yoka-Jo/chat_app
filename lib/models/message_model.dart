class MessageModel {
  String? message;
  String? time;
  String? senderId;
  String? receiverId;
  String? withWhom;

  MessageModel({
    required this.message,
    required this.time,
    required this.senderId,
    required this.receiverId,
    required this.withWhom,
  });

  MessageModel.fromJson(Map<String , dynamic>json){
    message = json["message"];
    time = json["time"];
    senderId = json["senderId"];
    receiverId = json["receiverId"];
    withWhom = json["withWhom"];
  }

  Map<String , dynamic> toMap(){
    return{
      "message":message,
      "time":time,
      "senderId":senderId,
      "receiverId":receiverId,
      "withWhom":withWhom,
    };
  }
}
