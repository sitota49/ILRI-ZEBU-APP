class ServiceDetail {
  final String? title;
  final String? quota;

  final List<String>? slots;

  ServiceDetail({required this.title, this.quota, this.slots});

  @override
  List<Object?> get props => [title, quota, slots];
  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    var service = ServiceDetail(
      title: json['title'],
      quota: json['field_quota'],
      slots: json['field_time_slots']?.split(','),
    );

    return service;
  }

  @override
  String toString() =>
      'ServiceDetail {title: $title, quota: $quota, slots:$slots}';
}
