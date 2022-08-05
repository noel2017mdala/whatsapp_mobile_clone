import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:whatsap_mobile_clone/screens/user_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';

class User_signUp extends StatefulWidget {
  User_signUp({Key? key}) : super(key: key);

  @override
  State<User_signUp> createState() => _User_signUpState();
}

Widget UserName(username) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "User Name",
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 60,
        child: TextField(
          controller: username,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.green,
              ),
              hintText: "User Name",
              hintStyle: TextStyle(
                color: Colors.green,
              )),
        ),
      )
    ],
  );
}

Widget Email(email) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Email",
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 60,
        child: TextField(
          controller: email,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.green,
              ),
              hintText: "Email",
              hintStyle: TextStyle(
                color: Colors.green,
              )),
        ),
      )
    ],
  );
}

Widget userPassword(password) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Password",
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 60,
        child: TextField(
          controller: password,
          obscureText: true,
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.green,
              ),
              hintText: "Password",
              hintStyle: TextStyle(
                color: Colors.green,
              )),
        ),
      )
    ],
  );
}

Widget userMobile(contact) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Phone Number",
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 60,
        child: TextField(
          controller: contact,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
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
  );
}

class _User_signUpState extends State<User_signUp> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool loader = false;
  bool msgState = false;
  String msgText = "";
  bool emailValidator = false;
  bool userNameValidator = false;
  bool contactValidator = false;
  bool passwordValidator = false;

  Widget SingInButton(context, userName, email, contact, password) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    void showToast(msg) {
      Fluttertoast.showToast(msg: msg, fontSize: 18);
    }

    void createUser(userName, email, contact, password) async {
      setState(() {
        loader = true;
      });

      try {
        var url =
            Uri.parse('http://192.168.43.93:8000/api/v1/users/createUser');

        var response = await http.post(url, body: {
          "name": userName,
          "email": email,
          "phoneNumber": contact,
          "password": password,
        });

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);

          showToast("user created successfully please log in");

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserLogin()),
          );
        } else {
          // print("pano");
          var jsonResponse = jsonDecode(response.body);
          // print(jsonResponse['']);
          setState(() {
            loader = false;
            msgState = true;
            msgText = jsonResponse['message'];
          });

          Future.delayed(Duration(seconds: 5), () {
            setState(() {
              loader = false;
              msgState = false;
              msgText = "";
            });
          });
        }
      } catch (err) {
        setState(() {
          loader = false;
          msgState = true;
          msgText = "Failed to create user please try again";
        });

        Future.delayed(Duration(seconds: 5), () {
          setState(() {
            loader = false;
            msgState = false;
            msgText = "";
          });
        });
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      width: screenWidth * 0.6,
      child: ElevatedButton(
        onPressed: loader
            ? null
            : () {
                // final bool isValid = EmailValidator.validate(email);
                // Navigator.push
                // (
                //     context, MaterialPageRoute(builder: (context) => UserDashboard()));

                if (userName == "" &&
                    email == "" &&
                    contact == "" &&
                    password == "") {
                  setState(() {
                    msgState = true;
                    msgText = "Please enter all values";
                  });

                  Future.delayed(Duration(seconds: 5), () {
                    setState(() {
                      loader = false;
                      msgState = false;
                      msgText = "";
                    });
                  });
                } else if (userName == "") {
                  setState(() {
                    userNameValidator = true;
                  });

                  Future.delayed(Duration(seconds: 5), () {
                    setState(() {
                      userNameValidator = false;
                    });
                  });
                } else if (email == "") {
                  setState(() {
                    emailValidator = true;
                  });

                  Future.delayed(Duration(seconds: 5), () {
                    setState(() {
                      emailValidator = false;
                    });
                  });
                } else if (!EmailValidator.validate(email)) {
                  setState(() {
                    msgState = true;
                    msgText = "Please enter a valid email address";
                  });

                  Future.delayed(Duration(seconds: 5), () {
                    setState(() {
                      loader = false;
                      msgState = false;
                      msgText = "";
                    });
                  });
                } else if (contact == "") {
                  setState(() {
                    contactValidator = true;
                  });

                  Future.delayed(Duration(seconds: 5), () {
                    setState(() {
                      contactValidator = false;
                    });
                  });
                } else if (contact.length < 8) {
                  setState(() {
                    msgState = true;
                    msgText = "Please enter a valid contact number";
                  });

                  Future.delayed(Duration(seconds: 5), () {
                    setState(() {
                      loader = false;
                      msgState = false;
                      msgText = "";
                    });
                  });
                } else if (password == '') {
                  setState(() {
                    passwordValidator = true;
                  });

                  Future.delayed(Duration(seconds: 5), () {
                    setState(() {
                      passwordValidator = false;
                    });
                  });
                } else if (password.length < 6) {
                  setState(() {
                    msgState = true;
                    msgText = "Password must contain 6 or more characters";
                  });

                  Future.delayed(Duration(seconds: 5), () {
                    setState(() {
                      loader = false;
                      msgState = false;
                      msgText = "";
                    });
                  });
                } else {
                  createUser(userName, email, contact, password);
                }
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
                "Create Account",
                style: TextStyle(
                    color: Color(0xFF00BFA5), fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
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
                      Color(0xFF00BFA5),
                      Color(0xFF00BFA5),
                      Color(0xFF00BFA5),
                      Color(0xFF00BFA5),
                    ])),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "logo.png",
                        width: 100.0,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Create Account",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      UserName(_userNameController),
                      userNameValidator ? SizedBox(height: 20) : Container(),
                      userNameValidator
                          ? Text("Please enter your username",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))
                          : Container(),
                      SizedBox(height: 20),
                      Email(_emailController),
                      emailValidator ? SizedBox(height: 20) : Container(),
                      emailValidator
                          ? Text("Please enter your Email",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))
                          : Container(),
                      SizedBox(height: 20),
                      userMobile(_contactController),
                      contactValidator ? SizedBox(height: 20) : Container(),
                      contactValidator
                          ? Text("Please enter your contact number",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))
                          : Container(),
                      SizedBox(height: 20),
                      userPassword(_passwordController),
                      passwordValidator ? SizedBox(height: 20) : Container(),
                      passwordValidator
                          ? Text("Please enter your password",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))
                          : Container(),
                      SizedBox(height: 10),
                      SingInButton(
                          context,
                          _userNameController.text,
                          _emailController.text,
                          _contactController.text,
                          _passwordController.text),
                      msgState
                          ? Text(msgText,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold))
                          : Container()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
