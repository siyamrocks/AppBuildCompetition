import 'dart:convert';

class School {
  School({
    this.id,
    this.name,
    this.slug,
    this.logo,
    this.address,
  });

  int id;
  String name;
  String slug;
  String logo;
  String address;

  factory School.fromJson(Map<String, dynamic> json) => School(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        logo: json["logo"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "logo": logo,
        "address": address,
      };
}
