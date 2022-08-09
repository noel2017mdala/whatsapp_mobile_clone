import 'package:flutter/material.dart';

class SenderMsg extends StatelessWidget {
  const SenderMsg({Key? key}) : super(key: key);

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
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                    style: TextStyle(fontSize: 16),
                  )),
              Positioned(
                bottom: 5,
                right: 12,
                child: Row(
                  children: [
                    Text(
                      "21:27",
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
