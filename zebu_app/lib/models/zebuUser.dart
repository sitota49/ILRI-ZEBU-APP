class ZebuUser {
  final String id;
  final String fullName;
  final String? email;
  final String? phoneNumber;

  ZebuUser(
      {required this.id, required this.fullName, this.email, this.phoneNumber});

  @override
  List<Object?> get props => [id, fullName, email, phoneNumber];
  factory ZebuUser.fromJson(Map<String, dynamic> json) {
    var zebuUser = ZebuUser(
      fullName: json['attributes']['title'],
      id: json['id'],
      email: json['attributes']['field_email']?.toString(),
      phoneNumber: json['attributes']['field_phonenumber']?.toString(),
    );

    return zebuUser;
  }

  @override
  String toString() =>
      'ZebuUser {id: $id , fullName: $fullName, email: $email, phoneNumber: $phoneNumber}';
}
