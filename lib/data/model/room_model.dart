class RoomModel {
  final String id;
  final String? name;
  final String? photo;
  final String? lastMessageSenderId;
  final String? lastMessageSenderName;
  final String? lastMessageContent;
  final DateTime? lastMessageSent;

  RoomModel({
    required this.id,
    this.name,
    this.photo,
    this.lastMessageSenderId,
    this.lastMessageSenderName,
    this.lastMessageContent,
    this.lastMessageSent,
  });

  RoomModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        photo = map['photo'],
        lastMessageSenderId = map['last_message_sender_id'],
        lastMessageSenderName = map['last_message_sender_name'],
        lastMessageContent = map['last_message_content'],
        lastMessageSent = DateTime.parse(map['last_message_sent']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photo'] = photo;
    data['last_message_sender_id'] = lastMessageSenderId;
    data['last_message_sender_name'] = lastMessageSenderName;
    data['last_message_content'] = lastMessageContent;
    data['last_message_sent'] = lastMessageSent;
    return data;
  }
}
