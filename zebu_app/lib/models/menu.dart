class Menu {
  final String id;
  final String? title;
  final String? description;
  final String? image;
  final String? memberPrice;

  final List<String>? category;

   final List<String>? type;

  Menu({required this.id, required this.title, this.description, this.image, this.category, this.memberPrice, this.type});

  @override
  List<Object?> get props => [id, title, description, image, category, memberPrice, type];
  factory Menu.fromJson(Map<String, dynamic> json) {
    var menu = Menu(
      title: json['title'],
      id: json['uuid'],
      description: json['field_menu_description']?.toString(),
      image: json['field_image'],
      category: json['field_category'].split(','),
      type: json['field_type'].split(','),
      memberPrice: json['field_member_price']
    );

    return menu;
  }

  @override
  String toString() =>
      'Menu {id: $id , title: $title, description: $description, image: $image, memberPrice:$memberPrice, categor:$category, type:$type}';
}
