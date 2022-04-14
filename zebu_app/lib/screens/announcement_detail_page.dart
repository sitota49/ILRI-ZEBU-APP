import 'package:flutter/material.dart';

class AnnouncementDetailPage extends StatefulWidget {
  final Map argObj;

  const AnnouncementDetailPage({Key? key, required this.argObj})
      : super(key: key);

  @override
  State<AnnouncementDetailPage> createState() =>
      _AnnouncementDetailPageState(argObj: argObj);
}

class _AnnouncementDetailPageState extends State<AnnouncementDetailPage> {
  final Map argObj;
  _AnnouncementDetailPageState({required this.argObj});
  @override
  Widget build(BuildContext context) {
    var id = argObj['id'];
    return Container(
      child: Text('announcement detail page ${id}'),
    );
  }
}
