class ServiceDetail {
  final String? title;
  final String? quota;
  final String? specDesc;

  final Map<dynamic, dynamic>? slots;

  ServiceDetail({required this.title, this.quota, this.slots, this.specDesc});

  @override
  List<Object?> get props => [title, quota, slots, specDesc];
  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    var slotsfromJson = json['field_time_slots']?.split(',');

    var slotMap = new Map();
    slotsfromJson.forEach((slotfromJson) => slotMap[slotfromJson] = 0);

    var service = ServiceDetail(
      title: json['title'],
      quota: json['field_quota'],
      slots: slotMap,
      specDesc: json['field_special_description'],
    );

    return service;
  }

  @override
  String toString() =>
      'ServiceDetail {title: $title, quota: $quota, slots:$slots, specDesc:$specDesc}';
}
