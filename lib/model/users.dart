import 'package:meta/meta.dart';

class Users {
  final String name;
  final String timeSent;
  final String userLastMessage;
  final String profileImage;

  const Users({
    required this.name,
    required this.timeSent,
    required this.userLastMessage,
    required this.profileImage,
  });

  static Users fromJson(json) => Users(
      name: json['name'],
      timeSent: json['timeSent'],
      userLastMessage: json['userLastMessage'],
      profileImage: json['profileImage']);
}
