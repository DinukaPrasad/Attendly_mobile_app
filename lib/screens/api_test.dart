import 'package:attendly/models/user.dart';
import 'package:attendly/services/test_user_api.dart';
import 'package:flutter/material.dart';

class ApiTest extends StatefulWidget {
  const ApiTest({super.key});

  @override
  State<ApiTest> createState() => _ApiTestState();
}

class _ApiTestState extends State<ApiTest> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Test')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final email = user.email;
                final phone = user.phone;
                final gender = user.gender;
                final name =
                    '${user.name.title} ${user.name.first} ${user.name.last}';

                return ListTile(
                  leading: Text('${index + 1}'),
                  title: Text(email),
                  subtitle: Text('$name\n$phone\n$gender'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void fetchUsers() async {
    final fetchedUsers = await TestUserApi.fetchUser();
    setState(() {
      users = fetchedUsers;
    });
  }
}
