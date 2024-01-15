import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/dependency_injection.dart';


import 'my_app.dart';

void main() {
  runApp(const MyApp());
  DependencyInjection.init();
}




