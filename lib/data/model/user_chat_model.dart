class UserModel {
  final String id;
  final String? name;
  final String? photo;

  UserModel({
    required this.id,
    this.name,
    this.photo,
  });

  UserModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        photo = map['photo'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photo'] = photo;
    return data;
  }
}
