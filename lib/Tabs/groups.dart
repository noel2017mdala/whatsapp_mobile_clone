import 'package:flutter/material.dart';

class Groups extends StatefulWidget {
  Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("This is a group"),
    );
  }
}
