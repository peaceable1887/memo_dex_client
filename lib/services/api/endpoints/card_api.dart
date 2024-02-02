import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CardApi
{
  final BuildContext context;
  final storage = FlutterSecureStorage();

  CardApi(this.context);
}