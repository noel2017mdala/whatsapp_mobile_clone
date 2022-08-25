import 'package:flutter/material.dart';

class SenderMsg extends StatelessWidget {
  const SenderMsg({Key? key, required this.msg, required this.msgTime})
      : super(key: key);
  final msg;
  final msgTime;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.74),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          color: Color(0xffdcf8c6),
          child: Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 60, top: 12, bottom: 20),
                  child: Text(
                    msg,
                    style: TextStyle(fontSize: 16),
                  )),
              Positioned(
                bottom: 5,
                right: 12,
                child: Row(
                  children: [
                    Text(
                      msgTime,
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.done_all,
                      size: 15,
                      color: Colors.blue,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
