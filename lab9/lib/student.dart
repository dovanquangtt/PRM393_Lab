
class Student {
  final int id;
  final String name;
  final String major;
  final int age;

  Student({
    required this.id,
    required this.name,
    required this.major,
    required this.age,
  });

  // Chuyển JSON thành đối tượng Student
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      name: json['name'] as String,
      major: json['major'] as String,
      age: json['age'] as int,
    );
  }

  // Chuyển đối tượng Student thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'major': major,
      'age': age,
    };
  }
}
