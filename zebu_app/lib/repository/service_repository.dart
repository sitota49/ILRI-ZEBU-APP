import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebu_app/models/service.dart';
import 'package:zebu_app/data_provider/service_data.dart';

class ServiceRepository {
  final ServiceDataProvider dataProvider;

  ServiceRepository({required this.dataProvider});

  Future<List<dynamic>> getAllService() async {
    return await dataProvider.getAllService();
  }

}
