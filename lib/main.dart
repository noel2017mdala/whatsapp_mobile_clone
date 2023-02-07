import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whatsap_mobile_clone/screens/user_login.dart';
import 'package:whatsap_mobile_clone/screens/user_tabs.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize SharedPreferences instance
  final SharedPreferences userToken = await SharedPreferences.getInstance();
  //gets user token from SharedPreferences instance
  var validateToken = userToken.getString("user_token");

  //check if the user token is expired
  bool hasExpired =
      validateToken == null ? true : JwtDecoder.isExpired(validateToken);

  final storage = new FlutterSecureStorage();
  var userData = await storage.read(key: "user_data");
  // var userToken = await storage.read(key: "user_token");
  if (userData != null) {
    var userId = jsonDecode(userData)["_id"];
    runApp(MaterialApp(
      //route to different pages based on the token
      home: !hasExpired ? User_Tabs(userData: userId) : UserLogin(),
    ));
  } else {
    runApp(MaterialApp(
      //route to different pages based on the token
      home: UserLogin(),
    ));
  }
  ;
}
