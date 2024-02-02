import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'endpoints/card_api.dart';
import 'endpoints/stack_api.dart';
import 'endpoints/user_api.dart';

class ApiClient
{
  final BuildContext context;
  final storage = FlutterSecureStorage();

  UserApi userApi;
  StackApi stackApi;
  CardApi cardApi;

  ApiClient(this.context)
      : userApi = UserApi(context),
        stackApi = StackApi(context),
        cardApi = CardApi(context);
}

