
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'student.dart';

class StudentStorage {
  static const String assetsPath = 'assets/students.json';
  static const String localFileName = 'students.json';

  // Đọc danh sách sinh viên từ file assets
  Future<List<Student>> loadAssetsStudents() async {
    final jsonString = await rootBundle.loadString(assetsPath);

    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList.map((item) {
      return Student.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  // Lấy file JSON trong vùng lưu trữ riêng của ứng dụng
  Future<File> getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/$localFileName');
  }

  // Đọc dữ liệu đã lưu; nếu chưa có file thì khởi tạo từ assets
  Future<List<Student>> loadStudents() async {
    final file = await getLocalFile();

    if (!await file.exists()) {
      final initialStudents = await loadAssetsStudents();
      await saveStudents(initialStudents);
      return initialStudents;
    }

    final jsonString = await file.readAsString();

    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList.map((item) {
      return Student.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  // Ghi danh sách sinh viên xuống file JSON
  Future<void> saveStudents(List<Student> students) async {
    final file = await getLocalFile();

    final jsonString = jsonEncode(
      students.map((student) => student.toJson()).toList(),
    );

    await file.writeAsString(jsonString);
  }
}
