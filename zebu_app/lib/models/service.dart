
class Service {
  final String id;
  final String? title;
  final String? description;
  final String? image;

  final List<String>? options;

  Service(
      {required this.id,
      required this.title,
      this.description,
      this.image,
      this.options});

  @override
  List<Object?> get props => [id, title, description, image, options];
  factory Service.fromJson(Map<String, dynamic> json) {
    var service = Service(
      title: json['title'],
      id: json['uuid'],
      description: json['field_service_description']?.toString(),
      image: json['field_image'] == '' ? null : json['field_image'],
      options: json['field_options']?.split(','),
    );

    return service;
  }

  @override
  String toString() =>
      'Service {id: $id , title: $title, description: $description, image: $image,  options:$options}';
}
