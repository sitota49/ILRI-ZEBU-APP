class MyFeedBack {
  final String? title;
  final String? email;
  final String? phoneNo;

  final int? foodRating;
  final int? serviceRating;
  final int? faciltiyRating;

  final String? improoveWhat;
  final String? dineOften;
  final String? englishCommuincation;
  final String? foodItemComment;
  final String? menudidntMatch;
  final String? menuAdded;
  final String? outStandingService;
  final String? otherComment;

  MyFeedBack({
    this.email,
    this.phoneNo,
    this.foodRating,
    this.serviceRating,
    this.faciltiyRating,
    this.improoveWhat,
    this.dineOften,
    this.englishCommuincation,
    this.foodItemComment,
    this.menudidntMatch,
    this.menuAdded,
    this.outStandingService,
    this.otherComment,
    this.title,
  });

  @override
  List<Object?> get props => [
        title,
        email,
        phoneNo,
        foodRating,
        serviceRating,
        faciltiyRating,
        improoveWhat,
        dineOften,
        englishCommuincation,
        foodItemComment,
        menudidntMatch,
        menuAdded,
        outStandingService,
        otherComment
      ];
  // factory MyFeedBack.fromJson(Map<String, dynamic> json) {
  //   var menu = MyFeedBack(
  //       title: json['title'],
  //       );

  //   return menu;
  // }

  @override
  String toString() =>
      'MyFeedBack {title: $title, email : $email,$phoneNo, $foodRating, $serviceRating, $faciltiyRating         $improoveWhat         $dineOften         $englishCommuincation         $foodItemComment         $menudidntMatch         $menuAdded         $outStandingService         $otherComment }';
}
