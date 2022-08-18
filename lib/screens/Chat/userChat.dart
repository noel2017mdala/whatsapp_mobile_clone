import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:whatsap_mobile_clone/screens/Chat/receiverMessage.dart';
import 'package:whatsap_mobile_clone/screens/Chat/senderMessage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../socket/socketconnection.dart';

class UserChart extends StatefulWidget {
  var userData;
  UserChart({Key? key, required this.userData}) : super(key: key);

  @override
  State<UserChart> createState() => _UserChartState();
}

class _UserChartState extends State<UserChart> {
  TextEditingController userMessage = TextEditingController();
  bool emojiState = false;
  FocusNode focusNode = FocusNode();
  // late IO.Socket socket;

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          emojiState = false;
        });
      }
    });
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${widget.userData.userLastSeen[0]['socketId'] == null ? "last seen ${widget.userData.userLastSeen[0]['lastSeenTime']}" : "online"} ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SenderMsg(),
                      ReceiverMsg(),
                      SenderMsg(),
                      ReceiverMsg(),
                      SenderMsg(),
                      ReceiverMsg(),
                      SenderMsg(),
                      ReceiverMsg()
                    ],
                  ),
                ),
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
                                      borderRadius: BorderRadius.circular(20)),
                                  child: TextFormField(
                                    focusNode: focusNode,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    controller: userMessage,
                                    maxLines: 100,
                                    minLines: 1,
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
                                      Icons.mic,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      // final storage =
                                      //     new FlutterSecureStorage();
                                      // var userData =
                                      //     await storage.read(key: "user_data");
                                      // var userToken =
                                      //     await storage.read(key: "user_token");
                                      // var userId = jsonDecode(userData!)["_id"];
                                      // var socket = SocketConn.connect(userId);

                                      //  socket.emit("request-demo");

                                      // print(userMessage.text);
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
        ),
      ),
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
