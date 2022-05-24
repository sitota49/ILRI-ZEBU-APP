class ZebuUser {
  final String name;
  final String? email;
  final String? phoneNumber;

  ZebuUser(
      { required this.name, this.email, this.phoneNumber});

  @override
  List<Object?> get props =>  [name, email, phoneNumber];


  ZebuUser.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        phoneNumber = json['phoneNumber'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
      };



  @override
  String toString() =>
      'ZebuUser {name: $name, email: $email, phoneNumber: $phoneNumber}';
}
