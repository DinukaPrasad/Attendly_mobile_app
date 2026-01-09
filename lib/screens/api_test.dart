import 'package:attendly/models/user.dart';
import 'package:attendly/services/test_user_api.dart';
import 'package:flutter/material.dart';

class ApiTest extends StatefulWidget {
  const ApiTest({super.key});

  @override
  State<ApiTest> createState() => _ApiTestState();
}

class _ApiTestState extends State<ApiTest> {
  List<User>? users;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Test')),
      body: users == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users!.length,
              itemBuilder: (context, index) {
                final user = users![index];
                return ListTile(
                  leading: Text('${index + 1}'),
                  title: Text(user.email),
                  subtitle: Text(
                    '${user.name.title} ${user.name.first} ${user.name.last}\n'
                    '${user.phone}\n${user.gender}',
                  ),
                );
              },
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
