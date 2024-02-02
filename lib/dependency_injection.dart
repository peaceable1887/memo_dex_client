import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:memo_dex_prototyp/utils/check_connection.dart';
import 'package:memo_dex_prototyp/screens/bottom_navigation_screen.dart';

class DependencyInjection
{
  static void init()
  {
    Get.put<CheckConnection>(CheckConnection(),permanent:true);
  }
}