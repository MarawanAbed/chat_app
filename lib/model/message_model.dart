

class MessageModel {
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime sendTime;
  final MessageType messageType;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.sendTime,
    required this.messageType,
  });


  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json["senderId"],
      receiverId: json["receiverId"],
      content: json["content"],
      sendTime: json["sendTime"].toDate(),
      messageType: getMessageTypeFromString(json["messageType"]),
    );
  }

  //create tomap
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'sendTime': sendTime,
      'messageType': messageType.name,
    };
  }

}

enum MessageType {
  textType,
  imageType,
  text,
  image,
}

MessageType getMessageTypeFromString(String json) {
  switch (json) {
    case 'text':
      return MessageType.textType;
    case 'image':
      return MessageType.imageType;
    default:
      throw Exception('Unsupported MessageType: $json');
  }
}

