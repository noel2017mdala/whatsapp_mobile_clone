import 'package:flutter/material.dart';
import 'package:whatsap_mobile_clone/Tabs/calls.dart';
import 'package:whatsap_mobile_clone/Tabs/camera.dart';
import 'package:whatsap_mobile_clone/Tabs/chat.dart';
import 'package:whatsap_mobile_clone/Tabs/groups.dart';
import 'package:whatsap_mobile_clone/Tabs/status.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class User_Tabs extends StatefulWidget {
  var userData;

  User_Tabs({Key? key, required this.userData}) : super(key: key);

  @override
  State<User_Tabs> createState() => _User_TabsState();
}

class _User_TabsState extends State<User_Tabs> {
  late IO.Socket socket;

  socketConn() {
    socket.connect();
    socket.onConnect((data) => print("Connection made successfully"));
    socket.onConnectError(
        (data) => print("Failed to connect to the server ${data}"));
    socket.onDisconnect((data) => print("Socket connection disconnected"));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socket = IO.io("http://192.168.43.93:8000/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "query": "mobileId=${widget.userData}",
    });

    socketConn();
  }

  _sendMessage(msg) {
    socket.emit(
        "request-demo", {"name": "Abel", "lastName": "Mdala", "msg": msg});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Whatsapp clone"),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 24.0,
                      semanticLabel: 'Search',
                    ),
                  ),
                  PopupMenuButton<String>(onSelected: (value) {
                    // print(value);
                  }, itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: Text("New Chart"),
                        value: "New Chart",
                      ),
                      PopupMenuItem(
                        child: Text("New Broadcast"),
                        value: "New Broadcast",
                      ),
                      PopupMenuItem(
                        child: Text("Link devices"),
                        value: "Link devices",
                      ),
                      PopupMenuItem(
                        child: Text("Starred messages"),
                        value: "Starred messages",
                      ),
                      PopupMenuItem(
                        child: Text("Settings"),
                        value: "Settings",
                      ),
                    ];
                  })
                ],
              ),
            ],
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF075E54),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              // Tab(
              //   icon: Icon(Icons.photo_camera),
              // ),
              Tab(
                text: "CHATS",
              ),
              Tab(text: "GROUPS"),
              Tab(
                text: "STATUS",
              ),
              Tab(
                text: "CALLS",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Chat(sendMessage: _sendMessage),
            Groups(),
            Status(),
            Calls()
          ],
        ),
      ),
    );
  }
}
