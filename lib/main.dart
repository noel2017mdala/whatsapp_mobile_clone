import 'package:flutter/material.dart';
import 'package:whatsap_mobile_clone/screens/user_login.dart';
import 'package:whatsap_mobile_clone/screens/user_tabs.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize SharedPreferences instance
  final SharedPreferences userToken = await SharedPreferences.getInstance();
  //gets user token from SharedPreferences instance
  var validateToken = userToken.getString("user_token");
  //check if the user token is expired
  bool hasExpired = JwtDecoder.isExpired(validateToken!);
  runApp(MaterialApp(
    //route to different pages based on the token
    home: !hasExpired ? User_Tabs() : UserLogin(),
  ));
}
