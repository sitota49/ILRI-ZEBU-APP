import 'package:zebu_app/data_provider/feedback_data.dart';
import 'package:zebu_app/models/feedback.dart';

class FeedbackRepository {
  final FeedbackDataProvider dataProvider;

  FeedbackRepository({required this.dataProvider});

  Future<List<dynamic>> createFeedback(MyFeedBack feedback) async {
    return await dataProvider.createFeedback(feedback);
  }

}
