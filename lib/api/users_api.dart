import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:whatsap_mobile_clone/model/users.dart';

class UsersApi {
  static Future<List<Users>> getUserList() async {
    final url = Uri.parse(
        'http://localhost:8000/api/v1/users/getUser/61b7336a571c140016f8577f');

    final response = await http.get(url, headers: {
      "access-token":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MWI3MzM2YTU3MWMxNDAwMTZmODU3N2YiLCJpYXQiOjE2NTM0NjU5ODgsImV4cCI6MTY1NDA3MDc4OH0.9p9psiE_t3AfIj9QsJ8IuA1eGdEzm1s2bnV26hQ7BpE",
      "user-id": "61b7336a571c140016f8577f"
    });

    final body = json.decode(response.body);
    print(body);

    return body.map<Users>(Users.fromJson).toList();
  }
}
