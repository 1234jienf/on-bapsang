import '../const/securetoken.dart';

class DataUtils {

  static String pathToUrl(String value) {
    return '$ip$value';
  }

  static DateTime dateTimeFromJson(String dateStr) {
    return DateTime.parse(dateStr);
  }

}