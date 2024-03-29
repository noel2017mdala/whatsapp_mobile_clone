import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:whatsap_mobile_clone/screens/Chat/receiverMessage.dart';
import 'package:whatsap_mobile_clone/screens/Chat/senderMessage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import '../../socket/socketconnection.dart';
// import 'package:whatsap_mobile_clone/screens/user_tabs.dart';

class userMessages {
  final String messageStatus;
  final String dateSent;
  final String timeSent;
  final String from;
  final String to;
  final String messagesBody;

  userMessages(this.messageStatus, this.dateSent, this.timeSent, this.from,
      this.to, this.messagesBody);

  factory userMessages.fromJson(Map<String, dynamic> json) {
    return userMessages(
      json["messageStatus"],
      json["dateSent"],
      json["timeSent"],
      json["from"],
      json["to"],
      json["messagesBody"],
    );
  }
}

class UserChart extends StatefulWidget {
  var userData;
  var userSendMessage;
  var userId;
  var socket;
  UserChart(
      {Key? key,
      required this.userData,
      required this.userSendMessage,
      required this.userId,
      required this.socket})
      : super(key: key);

  @override
  State<UserChart> createState() => _UserChartState();
}

class _UserChartState extends State<UserChart> {
  TextEditingController userMessage = TextEditingController();
  bool emojiState = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  List<userMessages> messages = [];

  // late IO.Socket socket;

  loadUserChart() async {
    final storage = new FlutterSecureStorage();
    var userData = await storage.read(key: "user_data");
    var userToken = await storage.read(key: "user_token");
    var userId = jsonDecode(userData!)["_id"];
    var receiverUrl = widget.userData.userLastSeen[0]['userId'];

    if (userId != null && receiverUrl != null) {
      var url = Uri.parse(
          "http://192.168.43.93:8000/api/v1/chat/getAllMessages/${userId}/${receiverUrl}");

      var response = await http.get(url,
          headers: {"access-token": userToken.toString(), "user-id": userId});

      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);

        var messagesData = userData['message'];

        for (var data in messagesData) {
          messages.add(new userMessages(
              data["messageStatus"],
              data["dateSent"],
              data["timeSent"],
              data["from"],
              data["to"],
              data["messagesBody"]));
        }

        setState(() {});
      } else {
        throw Exception('Unexpected error occurred!');
      }
    } else {
      print("Error here");
      throw Exception('Unexpected error occurred!');
    }
  }

  getUserLastMessage() async {
    final storage = new FlutterSecureStorage();
    var userData = await storage.read(key: "user_data");
    var userToken = await storage.read(key: "user_token");
    var userId = jsonDecode(userData!)["_id"];
    var receiverUrl = widget.userData.userLastSeen[0]['userId'];

    if (userId != null && receiverUrl != null) {
      var url = Uri.parse(
          "http://192.168.43.93:8000/api/v1/chat/getAllMessages/${userId}/${receiverUrl}");

      var response = await http.get(url,
          headers: {"access-token": userToken.toString(), "user-id": userId});

      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);

        var messagesData = userData['message'];

        var userMessage = messagesData[messagesData.length - 1];

        setState(() {
          messages.add(new userMessages(
              userMessage["messageStatus"],
              userMessage["dateSent"],
              userMessage["timeSent"],
              userMessage["from"],
              userMessage["to"],
              userMessage["messagesBody"]));
        });
      } else {
        throw Exception('Unexpected error occurred!');
      }
    } else {
      print("Error here");
      throw Exception('Unexpected error occurred!');
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserChart();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          emojiState = false;
        });
      }
    });
  }

  Widget userUi() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        return messages[index].from != widget.userId
            ? ReceiverMsg(
                msg: messages[index].messagesBody,
                msgTime: messages[index].timeSent,
              )
            : SenderMsg(
                msg: messages[index].messagesBody,
                msgTime: messages[index].timeSent,
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        "whatsapp_bg.png",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leadingWidth: 70,
            titleSpacing: 0,
            backgroundColor: Color(0xFF075E54),
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 24,
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        "https://node-whatsapp-backend.herokuapp.com/api/v1/users/getImage/${widget.userData.profileImage}"),
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ),
            title: InkWell(
              onTap: () {
                // print(widget.userData.userLastSeen[0]['socketId']);
                // print(widget.userData.userLastSeen[0]['lastSeenTime']);
              },
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userData.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${widget.userData.userLastSeen[0]['socketId'] == null ? "last seen ${widget.userData.userLastSeen[0]['lastSeenTime']}" : "online"} ",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.videocam)),
              IconButton(onPressed: () {}, icon: Icon(Icons.call)),
              PopupMenuButton<String>(onSelected: (value) {
                // print(value);
              }, itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: Text("View Contact"),
                    value: "View Contact",
                  ),
                  PopupMenuItem(
                    child: Text("Media, links, and docs"),
                    value: "media",
                  ),
                  PopupMenuItem(
                    child: Text("Search"),
                    value: "search",
                  ),
                  PopupMenuItem(
                    child: Text("Mute notifications"),
                    value: "mute",
                  ),
                  PopupMenuItem(
                    child: Text("Disappearing Message"),
                    value: "Disappearing",
                  ),
                  PopupMenuItem(
                    child: Text("Wallpaper"),
                    value: "wallpaper",
                  ),
                  PopupMenuItem(
                    child: Text("More"),
                    value: "more",
                  ),
                ];
              })
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WillPopScope(
              child: Stack(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height - 145,
                      child: messages.length == 0
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF075E54)),
                              ),
                            )
                          : userUi()),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Card(
                                    margin: EdgeInsets.only(
                                      left: 2,
                                      right: 2,
                                      bottom: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: TextFormField(
                                      focusNode: focusNode,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      keyboardType: TextInputType.multiline,
                                      controller: userMessage,
                                      maxLines: 100,
                                      minLines: 1,
                                      onChanged: (value) {
                                        if (value.length > 0) {
                                          setState(() {
                                            sendButton = true;
                                          });
                                        } else if (value.length <= 0) {
                                          setState(() {
                                            sendButton = false;
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Message",
                                          prefixIcon: IconButton(
                                            icon: Icon(Icons.emoji_emotions,
                                                color: Colors.grey),
                                            onPressed: () {
                                              focusNode.unfocus();
                                              focusNode.canRequestFocus = false;
                                              setState(() {
                                                emojiState = !emojiState;
                                              });
                                            },
                                          ),
                                          suffixIcon: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.attach_file,
                                                    color: Colors.grey,
                                                  )),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.camera_alt,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          contentPadding: EdgeInsets.all(5)),
                                    ))),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, bottom: 12, right: 4),
                                child: CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(200, 7, 133, 91),
                                  radius: 25,
                                  child: IconButton(
                                      icon: Icon(
                                        sendButton ? Icons.send : Icons.mic,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        final storage =
                                            new FlutterSecureStorage();
                                        var userData = await storage.read(
                                            key: "user_data");
                                        var userToken = await storage.read(
                                            key: "user_token");
                                        var userId =
                                            jsonDecode(userData!)["_id"];
                                        var receiverUrl = widget
                                            .userData.userLastSeen[0]['userId'];

                                        var userSessionData =
                                            jsonDecode(userData);

                                        var messageContent = {
                                          "from": userId,
                                          "to": receiverUrl,
                                          "messagesBody": userMessage.text,
                                          "data": {
                                            "userData": userSessionData,
                                            "userId": receiverUrl
                                          }
                                        };

                                        // widget.socket.on(
                                        //     "receive-message",
                                        //     (message, messageData) =>
                                        //         print(message));

                                        // widget.socket.on("demoBroadcast",
                                        //     () => print("wawa2"));

                                        // widget.socket.on("re-fresh-contact",
                                        //     () => print("wawa3"));

                                        // widget.socket.on("re-fresh-contact",
                                        //     (data) => print("mojo"));

                                        // print(messageContent);
                                        widget.userSendMessage(messageContent);

                                        userMessage.clear();

                                        widget.socket.on("demo",
                                            (data) => getUserLastMessage());

                                        widget.socket.on("demoBroadcast",
                                            (data) => getUserLastMessage());

                                        widget.socket.on("receive-message",
                                            (data) => print("WaWA"));
                                      }),
                                ))
                          ],
                        ),
                        emojiState ? userEmojiPicker() : Container()
                      ],
                    ),
                  )
                ],
              ),
              onWillPop: () {
                if (emojiState) {
                  setState(() {
                    emojiState = false;
                  });
                } else {
                  Navigator.pop(context);
                }

                return Future.value(false);
              },
            ),
          )),
    ]);
  }

  Widget userEmojiPicker() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width - 10,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          // print(emoji);

          setState(() {
            userMessage.text = userMessage.text + emoji.emoji;
          });
        },
        onBackspacePressed: () {},
        config: Config(
          columns: 7,
        ),
      ),
    );
  }
}
