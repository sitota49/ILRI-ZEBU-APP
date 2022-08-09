class Announcement {
  final String id;
  final String title;
  final String? description;
  final String? date;
  final String? image;

  Announcement(
      {required this.id,
      required this.title,
      this.description,
      this.date,
      this.image});

  @override
  List<Object?> get props => [id, title, description, date, image];
  factory Announcement.fromJson(Map<String, dynamic> json) {
    var announcement = Announcement(
      title: json['title'],
      id: json['uuid'],
      description: json['field_description'],
      date: json['field_date_announcement'],
      image: json['field_image'] == '' ? null : json['field_image'],
    );

    return announcement;
  }

  @override
  String toString() =>
      'Announcement {id: $id , title: $title, description: $description, date: $date, image: $image}';
}
