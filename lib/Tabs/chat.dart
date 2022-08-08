import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:whatsap_mobile_clone/screens/userChart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:whatsap_mobile_clone/screens/Chat/userChat.dart';

class userChart {
  final String profileImage;
  final String name;
  final String lastMassage;
  final String messageTime;
  final String messageStatus;
  final List userLastSeen;

  userChart(this.profileImage, this.name, this.lastMassage, this.messageTime,
      this.messageStatus, this.userLastSeen);

  factory userChart.fromJson(Map<String, dynamic> json) {
    return userChart(
        json["userDetails"]["profileImage"],
        json['userDetails']["name"],
        json['userLastMessage']['messagesBody'],
        json["userLastMessage"]["timeSent"],
        json["userLastMessage"]["messageStatus"],
        json['userDetails']["userActivity"]);
  }
}

class Chat extends StatefulWidget {
  Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

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
        body: RefreshIndicator(
          onRefresh: getUsers,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: FutureBuilder<List<userChart>>(
                  future: getUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || snapshot.data == null) {
                      return Align(
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF075E54)),
                          ),
                        ),
                      );
                    } else {
                      List<userChart>? list = snapshot.data;
                      if (list!.length > 0) {
                        // return Text("Hello ${snapshot.data![0].name}");

                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                // print(snapshot.data![index]);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserChart(
                                              userData: snapshot.data![index],
                                            )));
                              },
                              child: Card(
                                child: ListTile(
                                    leading: InkWell(
                                      onTap: () {},
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            "https://node-whatsapp-backend.herokuapp.com/api/v1/users/getImage/${snapshot.data![index].profileImage}"),
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                    trailing:
                                        Text(snapshot.data![index].messageTime),
                                    title: Text(
                                      snapshot.data![index].name,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        snapshot.data![index].messageStatus ==
                                                "read"
                                            ? Icon(
                                                Icons.done_all,
                                                size: 15,
                                                color: Colors.blue,
                                              )
                                            : snapshot.data![index]
                                                        .messageStatus ==
                                                    "sent"
                                                ? Icon(
                                                    Icons.done,
                                                    color: Colors.grey,
                                                  )
                                                : Icon(Icons.done_all,
                                                    color: Colors.grey),
                                        SizedBox(width: 5),
                                        Text(
                                          snapshot.data![index].lastMassage,
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            );
                          },
                        );
                      } else {
                        return Text("No charts found");
                      }
                    }
                  },
                )),
          ),
        ));
  }
}
