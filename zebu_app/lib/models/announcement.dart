class Announcement {
  final String id;
  final String title;
  final String body;
  final String date;

  Announcement(
      {
      required this.id,
      required this.title,
      required this.body,
      required this.date});

  @override
  List<Object?> get props => [id, title, body, date];
  factory Announcement.fromJson(Map<String, dynamic> json) {
    var announcement = Announcement(
        title: json['attributes']['title'],
        id: json['id'],
        body: json['attributes']['body']['value'],
        date: json['attributes']['created'],
  );

    return announcement;
  }

  @override
  String toString() => 'Announcement {id: $id , title: $title, body: $body}';
}
