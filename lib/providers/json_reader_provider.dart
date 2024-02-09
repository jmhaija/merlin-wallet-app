import 'package:flutter/services.dart';

Future<String> readJson(String filename) async {
  return await rootBundle.loadString(filename);
}
