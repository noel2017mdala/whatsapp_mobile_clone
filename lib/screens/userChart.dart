import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:whatsap_mobile_clone/api/users_api.dart';
import 'package:whatsap_mobile_clone/model/users.dart';

// class UserChartList extends StatefulWidget {
//   UserChartList({Key? key}) : super(key: key);

//   @override
//   State<UserChartList> createState() => _UserChartListState();
// }

// class _UserChartListState extends State<UserChartList> {
//   void getUserChat() async {
//     try {
//       var url = Uri.parse(
//           'http://localhost:8000/api/v1/users/getUser/61b7336a571c140016f8577f');
//       var response = await http.get(url, headers: {
//         "access-token":
//             "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MWI3MzM2YTU3MWMxNDAwMTZmODU3N2YiLCJpYXQiOjE2NTM0NjU5ODgsImV4cCI6MTY1NDA3MDc4OH0.9p9psiE_t3AfIj9QsJ8IuA1eGdEzm1s2bnV26hQ7BpE",
//         "user-id": "61b7336a571c140016f8577f"
//       });
//     } catch (err) {
//       print(err);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

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
