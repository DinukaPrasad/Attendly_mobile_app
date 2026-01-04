import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiTest extends StatefulWidget {
  const ApiTest({super.key});

  @override
  State<ApiTest> createState() => _ApiTestState();
}

class _ApiTestState extends State<ApiTest> {
  List<dynamic> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Test')),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUser,
        child: const Icon(Icons.send),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final email = user['email'];
                final phone = user['phone'];
                final name = user['name']['first'];
                final location = user['location']['street']['number'];
                final imageUrl = user['picture']['thumbnail'];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  title: Text(email),
                  subtitle: Text('$name, $phone, $location'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void fetchUser() async {
    print('api test button pressed');

    const url = 'https://randomuser.me/api/?results=20';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;

    final json = jsonDecode(body);

    setState(() {
      users = json['results'];
    });

    print('Fetched ${users.length} users');
  }
}
