import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whatsap_mobile_clone/screens/userChart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class userChart {
  final String profileImage;
  final String name;
  final String lastMassage;
  final String messageTime;

  userChart(this.profileImage, this.name, this.lastMassage, this.messageTime);

  factory userChart.fromJson(Map<String, dynamic> json) {
    // print(json["userDetails"]);
    return userChart(
        json["userDetails"]["profileImage"],
        json['userDetails']["name"],
        json['userLastMessage']['messagesBody'],
        json["userLastMessage"]["timeSent"]);
  }
}

class Chat extends StatefulWidget {
  Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

/*
 headers: {
        "access-token": generateToken(),
        "user-id": getUserDAta()._id,
      },
*/

class _ChatState extends State<Chat> {
  Future<List<userChart>> getUsers() async {
    final storage = new FlutterSecureStorage();
    var userData = await storage.read(key: "user_data");
    var userToken = await storage.read(key: "user_token");
    var userId = jsonDecode(userData!)["_id"];

    if (userId != null) {
      var url =
          Uri.parse("http://192.168.43.93:8000/api/v1/users/getUser/${userId}");

      var response = await http.get(url,
          headers: {"access-token": userToken.toString(), "user-id": userId});

      if (response.statusCode == 200) {
        List users = jsonDecode(response.body);
        // print(users);

        return users.map((e) => new userChart.fromJson(e)).toList();
      } else {
        throw Exception('Unexpected error occurred!');
      }
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: Icon(Icons.chat),
        backgroundColor: Color(0xFF075E54),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<List<userChart>>(
                future: getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError || snapshot.data == null) {
                    // print(snapshot.error);
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    // print(snapshot.data![1].name);
                    return Text("Hello ${snapshot.data![0].name}");
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
