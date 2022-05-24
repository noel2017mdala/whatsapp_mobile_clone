import 'package:flutter/material.dart';

class Calls extends StatefulWidget {
  Calls({Key? key}) : super(key: key);

  @override
  State<Calls> createState() => _CallsState();
}

class _CallsState extends State<Calls> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("These are calls"),
    );
  }
}
