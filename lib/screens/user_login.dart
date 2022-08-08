import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsap_mobile_clone/screens/user_sign_up.dart';
import 'package:whatsap_mobile_clone/screens/user_tabs.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLogin extends StatefulWidget {
  UserLogin({Key? key}) : super(key: key);

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final storage = new FlutterSecureStorage();
  bool loader = false;
  bool msgState = false;
  String msgText = "";
  bool userContactState = false;
  bool userPasswordState = false;

  void userAuthenticator(
      String userContact, String userPassword, context) async {
    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    if (userContact.length == 0 && userPassword.length == 0) {
      setState(() {
        loader = false;
        userContactState = true;
        userPasswordState = true;
      });

      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          loader = false;
          userContactState = false;
          userPasswordState = false;
        });
      });
    } else if (userContact.length == 0) {
      setState(() {
        loader = false;
        userContactState = true;
        // userPasswordState = true;
      });
      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          loader = false;
          userContactState = false;
          userPasswordState = false;
        });
      });
    } else if (userContact.length < 10) {
      // setState(() {
      //   loader = false;
      //   userContactState = true;
      //   // userPasswordState = true;
      // });
      // Future.delayed(Duration(seconds: 5), () {
      //   setState(() {
      //     loader = false;
      //     userContactState = false;
      //     userPasswordState = false;
      //   });
      // });

      setState(() {
        loader = false;
        msgState = true;
        msgText = "Please enter a valid contact number";
      });

      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          loader = false;
          msgState = false;
        });
      });
    } else if (userPassword.length < 6) {
      // setState(() {
      //   loader = false;
      //   userContactState = true;
      //   userPasswordState = true;
      // });
      // Future.delayed(Duration(seconds: 5), () {
      //   setState(() {
      //     loader = false;
      //     userContactState = false;
      //     userPasswordState = false;
      //   });
      // });

      setState(() {
        loader = false;
        msgState = true;
        msgText = "Password must contain 6 or more characters";
      });

      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          loader = false;
          msgState = false;
        });
      });
    } else {
      try {
        setState(() {
          loader = true;
          userContactState = false;
          userPasswordState = false;
        });

        var url = Uri.parse('http://192.168.43.93:8000/api/v1/users/login');
        var response = await http
            .post(url, body: {"password": userPassword, "email": userContact});
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);

          var userData = jsonResponse['loginDetails']['userDetails'];
          var header = jsonResponse["loginDetails"]["headers"]["header"];
          var payload = jsonResponse["loginDetails"]["headers"]["payload"];
          var signature = jsonResponse["loginDetails"]["signature"];

          var token = "$header.$payload.$signature";

          await storage.write(key: "user_token", value: token);
          await storage.write(key: "user_data", value: jsonEncode(userData));

          final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();

          sharedPreferences.setString('user_token', token);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => User_Tabs()),
            (Route<dynamic> route) => false,
          );

          setState(() {
            loader = false;
          });
        } else {
          var jsonResponse = json.decode(response.body);

          setState(() {
            loader = false;
            msgState = true;
            msgText = jsonResponse['Message'];
          });

          Future.delayed(Duration(seconds: 5), () {
            setState(() {
              loader = false;
              msgState = false;
            });
          });
        }
      } catch (err) {
        // print(err);

        setState(() {
          loader = false;
          msgState = true;
          msgText = "Failed to login please try again";
        });

        Future.delayed(Duration(seconds: 5), () {
          setState(() {
            loader = false;
            msgState = false;
          });
        });
      }
    }
  }

  Future checkToken() async {
    var res = await storage.read(key: "user_token");
    return res;
  }

  Widget SingInButton(context, userContact, userPassword) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      width: screenWidth * 0.6,
      child: ElevatedButton(
        onPressed: loader
            ? null
            : () {
                userAuthenticator(userContact, userPassword, context);
              },
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 255, 255, 255),
        ),
        child: loader
            ? SizedBox(
                child: CircularProgressIndicator(
                  color: Color(0xFF00BFA5),
                ),
                height: 20.0,
                width: 20.0,
              )
            : Text(
                "Log in",
                style: TextStyle(
                    color: Color(0xFF00BFA5), fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget signUpButton(context) {
    return GestureDetector(
      onTap: () async {
        // var data = await checkToken();

        // bool hasExpired = JwtDecoder.isExpired(data);

        // print(hasExpired);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => User_signUp()),
        );
      },
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: "Don\'t have an account? ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
              text: "Sign up",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ))
        ]),
      ),
    );
  }

  Widget userForgotPassword() {
    return Container(
        // height: 70.0,
        // width: 70.0,
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {},
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: "Forgot Password?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ]),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion(
            value: SystemUiOverlayStyle.light,
            child: GestureDetector(
              child: GestureDetector(
                child: Stack(
                  children: [
                    Container(
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Color(0xFF075E54),
                              Color(0xFF075E54),
                              Color(0xFF075E54),
                              Color(0xFF075E54),
                            ])),
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 40,
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                "logo.png",
                                width: 100.0,
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Log In",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Phone Number",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 6,
                                              offset: Offset(0, 2))
                                        ]),
                                    height: 60,
                                    child: TextField(
                                      controller: _phoneNumberController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(color: Colors.black87),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              EdgeInsets.only(top: 14),
                                          prefixIcon: Icon(
                                            Icons.phone,
                                            color: Colors.green,
                                          ),
                                          hintText: "Mobile Number",
                                          hintStyle: TextStyle(
                                            color: Colors.green,
                                          )),
                                    ),
                                  )
                                ],
                              ),
                              userContactState
                                  ? SizedBox(height: 20)
                                  : Container(),
                              userContactState
                                  ? Text("Please enter you phone number",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))
                                  : Container(),
                              SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Password",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 6,
                                              offset: Offset(0, 2))
                                        ]),
                                    height: 60,
                                    child: TextField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      style: TextStyle(color: Colors.black87),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              EdgeInsets.only(top: 14),
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: Colors.green,
                                          ),
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                            color: Colors.green,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              userPasswordState
                                  ? SizedBox(height: 20)
                                  : Container(),
                              userPasswordState
                                  ? Text("Please enter you password",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))
                                  : Container(),
                              SizedBox(height: 20),
                              userForgotPassword(),
                              SingInButton(context, _phoneNumberController.text,
                                  _passwordController.text),
                              signUpButton(context),
                              SizedBox(height: 20),
                              msgState
                                  ? Text(msgText,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))
                                  : Container()
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            )));
  }
}
