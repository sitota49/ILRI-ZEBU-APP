class ServiceDetail {
  final String? title;
  final String? quota;

  final Map<dynamic, dynamic>? slots;

  ServiceDetail({required this.title, this.quota, this.slots});

  @override
  List<Object?> get props => [title, quota, slots];
  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    var slotsfromJson = json['field_time_slots']?.split(',');

    var slotMap = new Map();
    slotsfromJson.forEach((slotfromJson) => slotMap[slotfromJson] = 0);

    var service = ServiceDetail(
      title: json['title'],
      quota: json['field_quota'],
      slots: slotMap,
    );

    return service;
  }

  @override
  String toString() =>
      'ServiceDetail {title: $title, quota: $quota, slots:$slots}';
}
