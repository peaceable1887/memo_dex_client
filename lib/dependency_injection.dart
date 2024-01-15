import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:memo_dex_prototyp/helperClasses/check_connection.dart';

class DependencyInjection
{
  static void init()
  {
    Get.put<CheckConnection>(CheckConnection(),permanent:true);
  }
}