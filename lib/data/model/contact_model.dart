class ContactModel {
  final String id;
  final String userId;
  final String roomId;
  final DateTime lastActiveLocal;
  final DateTime lastActiveServer;
  final String? contactId;
  final String? contactName;
  final String? contactPhoto;

  ContactModel({
    required this.id,
    required this.userId,
    required this.roomId,
    required this.lastActiveLocal,
    required this.lastActiveServer,
    this.contactId,
    this.contactName,
    this.contactPhoto,
  });

  ContactModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        userId = map['user_id'],
        roomId = map['room_id'],
        lastActiveLocal = DateTime.parse(map['last_active_local']),
        lastActiveServer = DateTime.parse(map['last_active_server']),
        contactId = map['contact_id'],
        contactName = map['contact_name'],
        contactPhoto = map['contact_photo'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['room_id'] = roomId;
    data['last_active_local'] = lastActiveLocal;
    data['last_active_server'] = lastActiveServer;
    data['contact_id'] = contactId;
    data['contact_name'] = contactName;
    data['contact_photo'] = contactPhoto;
    return data;
  }
}
