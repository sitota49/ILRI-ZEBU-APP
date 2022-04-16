import 'dart:convert';

class Menu {
  final String id;
  final String? title;
  final String? description;
  final String? image;
  final String? memberPrice;

  final List<String>? category;

  final List<String>? type;

  Menu(
      {required this.id,
      required this.title,
      this.description,
      this.image,
      this.category,
      this.memberPrice,
      this.type});

  @override
  List<Object?> get props =>
      [id, title, description, image, category, memberPrice, type];
  factory Menu.fromJson(Map<String, dynamic> json) {
    var menu = Menu(
        title: json['title'],
        id: json['uuid'],
        description: json['field_menu_description']?.toString(),
        image: json['field_image'],
        category: json['field_category']?.split(','),
        type: json['field_type']?.split(','),
        memberPrice: json['field_member_price']);

    return menu;
  }

  @override
  String toString() =>
      'Menu {id: $id , title: $title, description: $description, image: $image, memberPrice:$memberPrice, categor:$category, type:$type}';

  // Map<String, dynamic> toJson() {
  //   var jsonCategory = jsonEncode(category);
  //   var jsonType = jsonEncode(type);
  //   return {
  //     'id': id,
  //     'title': title,
  //     'description': description,
  //     'image': image,
  //     'type': jsonType,
  //     'category': jsonCategory,
  //     'memberPrice': memberPrice,
  //   };
  // }

  // static Map<String, dynamic> toMap(Menu menu) => {
  //       'id': menu.id,
  //       'title': menu.title,
  //       'description': menu.description,
  //       'image': menu.image,
  //       'memberPrice': menu.memberPrice,
  //       'category': menu.category,
  //       'type': menu.type,
  //     };

  // static String encode(List<Menu> menus) => json.encode(
  //       menus.map<Map<String, dynamic>>((menu) => Menu.toMap(menu)).toList(),
  //     );

  // static List<Menu> decode(String menus) =>
  //     (json.decode(menus) as List<dynamic>)
  //         .map<Menu>((item) => Menu.fromJson(item))
  //         .toList();
}
