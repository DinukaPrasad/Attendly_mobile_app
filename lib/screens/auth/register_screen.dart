import 'package:attendly/models/student.dart';
import 'package:attendly/services/test_student_api.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<Student>? students;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: students == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: students!.length,
              itemBuilder: (context, index) {
                final student = students![index];
                return ListTile(
                  leading: Text('${index + 1}'),
                  title: Text(student.fullName),
                  subtitle: Text('${student.email}\n${student.id}'),
                );
              },
            ),
    );
  }

  void fetchStudents() async {
    try {
      final fetchedStudents = await TestStudentApi.fetchAllStudents();
      setState(() {
        students = fetchedStudents;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
