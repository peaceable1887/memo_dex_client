import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class CheckConnection extends GetxController
{
  final Connectivity _connectivity = Connectivity();
  final storage = FlutterSecureStorage();

  @override
  void onInit()
  {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult)
  {
    if (connectivityResult == ConnectivityResult.none)
    {
      Get.rawSnackbar(
          messageText: Center(
            child: const Text(
                'No internet connection. Limited functionality.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400
                )
            ),
          ),
          isDismissible: false,
          duration: const Duration(days: 1),
          backgroundColor: Colors.red[400]!,
          icon : Center(child: const Icon(Icons.wifi_off, color: Colors.white, size: 22,)),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          snackStyle: SnackStyle.GROUNDED,
          borderRadius: 10,
      );
      storage.write(key: 'internet_connection', value: "false");

    }else
    {
      if (Get.isSnackbarOpen)
      {
        storage.write(key: 'internet_connection', value: "true");
        Get.closeCurrentSnackbar();
      }
    }
  }
}