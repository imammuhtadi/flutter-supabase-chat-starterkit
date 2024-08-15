extension ContextExt on MessageModel {
  bool isMine(String myId) {
    return senderId == myId;
  }
}

class MessageModel {
  final String id;
  final String? content;
  final String senderId;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.content,
    required this.senderId,
    required this.createdAt,
  });

  MessageModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        content = map['content'],
        senderId = map['sender_id'],
        createdAt = DateTime.parse(map['created_at']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['sender_id'] = senderId;
    data['created_at'] = createdAt;
    return data;
  }
}
