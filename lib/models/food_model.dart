class Food {
  Food({
    this.date,
    this.menuItems,
    this.images,
  });

  DateTime date;
  List<String> menuItems;
  List<String> images;

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        date: DateTime.parse(json["date"]),
        menuItems: List<String>.from(json["menu_items"].map((x) => x)),
        images: List<String>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "menu_items": List<dynamic>.from(menuItems.map((x) => x)),
        "images": List<dynamic>.from(images.map((x) => x)),
      };
}
