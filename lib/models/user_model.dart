//User Model
class UserModel {
  String uid;
  String id;
  String email;
  String name;
  String photoUrl;

  UserModel({this.uid, this.id, this.email, this.name, this.photoUrl});

  factory UserModel.fromMap(Map data) {
    return UserModel(
      uid: data['uid'],
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "id": id,
        "email": email,
        "name": name,
        "photoUrl": photoUrl
      };
}
