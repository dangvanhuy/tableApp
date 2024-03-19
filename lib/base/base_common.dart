
import 'package:shared_preferences/shared_preferences.dart';
class BaseCommon {
  static BaseCommon? _instance;
  String? branchTableToken;

  BaseCommon._internal();

  static BaseCommon get instance {
    _instance ??= BaseCommon._internal();
    return _instance!;
  }

  
}
