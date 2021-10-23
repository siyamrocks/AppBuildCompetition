//User Model
class UserModel {
  String uid;
  String id;
  String email;
  String name;
  String school;
  String photoUrl;

  UserModel(
      {this.uid, this.id, this.email, this.name, this.school, this.photoUrl});

  factory UserModel.fromMap(Map data) {
    return UserModel(
      uid: data['uid'],
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      school: data['school'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "id": id,
        "email": email,
        "name": name,
        "school": school,
        "photoUrl": photoUrl
      };
}
