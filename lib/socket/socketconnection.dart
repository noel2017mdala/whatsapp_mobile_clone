import 'package:socket_io_client/socket_io_client.dart' as IO;

late IO.Socket socket;

class SocketConn {
  static connect(userId) {
    socket = IO.io("http://192.168.43.93:8000/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "query": "mobileId=${userId}",
    });

    socket.connect();
    socket.onConnect((data) => print("socket connected successfully"));
    print(socket.connected);

    return socket;
  }
}
