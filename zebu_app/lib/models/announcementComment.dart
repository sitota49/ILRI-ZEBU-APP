class AnnouncementComment {
  final String? announcementId;
  final String title;
  final String? comment;
  final String? phoneNo;
  final String? email;

  AnnouncementComment(
      {this.announcementId,
      required this.title,
      this.comment,
      this.phoneNo,
      this.email});

  @override
  List<Object?> get props => [announcementId, title, comment, phoneNo, email];
  // factory AnnouncementComment.fromJson(Map<String, dynamic> json) {
  //   var announcementComment = AnnouncementComment(
  //     title: json['title'],
  //     announcementId: json['uuid'],
  //     comment: json['field_comment'],
  //     phoneNo: json['field_phoneNo_announcementComment'],
  //     email: json['field_email'] == '' ? null : json['field_email'],
  //   );

  //   return announcementComment;
  // }

  @override
  String toString() =>
      'AnnouncementComment {announcementId: $announcementId , title: $title, comment: $comment, phoneNo: $phoneNo, email: $email}';
}
