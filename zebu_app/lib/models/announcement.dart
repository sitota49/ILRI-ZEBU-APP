class Announcement {
  final String id;
  final String title;
  final String description;
  final String date;

  Announcement(
      {
      required this.id,
      required this.title,
      required this.description,
      required this.date});

  @override
  List<Object?> get props => [id, title, description, date];
  factory Announcement.fromJson(Map<String, dynamic> json) {
    var announcement = Announcement(
        title: json['attributes']['title'],
        id: json['id'],
        description: json['attributes']['field_description'],
        date: json['attributes']['created'],
  );

    return announcement;
  }

  @override
  String toString() => 'Announcement {id: $id , title: $title, description: $description, date: $date}';
}
