import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserApi
{
  final BuildContext context;
  final storage = FlutterSecureStorage();

  UserApi(this.context);
}