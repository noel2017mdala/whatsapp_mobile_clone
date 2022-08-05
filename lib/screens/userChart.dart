import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:whatsap_mobile_clone/api/users_api.dart';
import 'package:whatsap_mobile_clone/model/users.dart';

class userChart {
  final String phonenumber;
  final String dates;
  final String transdetails;
  final String description;
  final String Amount;
  final String Balance;
  final int transid;

  userChart(this.phonenumber, this.dates, this.transdetails, this.description,
      this.Amount, this.Balance, this.transid);

  factory userChart.fromJson(Map<String, dynamic> json) {
    return userChart(json["phonenumber"], json["dates"], json["transdetails"],
        json["description"], json["Amount"], json["balance"], json["transid"]);
  }
}

class UserChartList extends StatelessWidget {
  const UserChartList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Users>>(
            future: UsersApi.getUserList(),
            builder: (context, snapshot) {
              final users = snapshot.data;

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("An error occurred"),
                    );
                  } else {
                    return buildUserList(users!);
                  }
              }
            }));
  }

  Widget buildUserList(List<Users> users) => ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return ListTile(
          title: Text(user.name),
        );
      });
}
