import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebu_app/data_provider/menu_data.dart';

class MenuRepository {
  final MenuDataProvider dataProvider;

  MenuRepository({required this.dataProvider});

  Future<List<dynamic>> getAllMenu(queryParam) async {
    return await dataProvider.getAllMenu(queryParam);
  }

  Future<dynamic> getCategoryMenu(String id) async {
    return await dataProvider.getCategoryMenu(id);
  }

  Future<dynamic> getSingleMenu(String id) async {
    return await dataProvider.getSingleMenu(id);
  }

  Future<dynamic> getRecentlyviewed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var recentlyViewedList = prefs.getStringList('recentlyViewed');
    return recentlyViewedList;
  }
}
