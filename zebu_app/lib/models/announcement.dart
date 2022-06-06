class Announcement {
  final String id;
  final String title;
  final String? description;
  final String? date;

  Announcement(
      {required this.id, required this.title, this.description, this.date});

  @override
  List<Object?> get props => [id, title, description, date];
  factory Announcement.fromJson(Map<String, dynamic> json) {
   
    var announcement = Announcement(
      title: json['title'],
      id: json['uuid'],
      description: json['field_description'],
      date: json['field_date_announcement'],
    );
    
    return announcement;
  }

  @override
  String toString() =>
      'Announcement {id: $id , title: $title, description: $description, date: $date}';
}
