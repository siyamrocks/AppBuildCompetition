//User Model
class UserModel {
  String uid;
  String id;
  String email;
  String name;
  String school;
  String studentvue;
  List<dynamic> todos;

  UserModel(
      {this.uid, this.id, this.email, this.name, this.school, this.studentvue});

  factory UserModel.fromMap(Map data) {
    return UserModel(
        uid: data['uid'],
        id: data['id'] ?? '',
        email: data['email'] ?? '',
        name: data['name'] ?? '',
        school: data['school'] ?? '',
        studentvue: data['studentvue'] ?? '');
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "id": id,
        "email": email,
        "name": name,
        "school": school,
        "studentvue": studentvue,
      };
}
