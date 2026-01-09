class Student {
  late String id;
  late String fullName;
  late String email;

  Student({required this.id, required this.fullName, required this.email});

  // Getters
  String get getId => id;
  String get getFullName => fullName;
  String get getEmail => email;

  // Setters
  set setId(String value) => id = value;
  set setFullName(String value) => fullName = value;
  set setEmail(String value) => email = value;

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'fullName': fullName, 'email': email};
  }

  // Convert from JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
    );
  }

  // Convert list from JSON
  static List<Student> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Student.fromJson(json)).toList();
  }
}
