
import 'package:flutter/material.dart';

import 'student.dart';
import 'student_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 9',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const StudentScreen(),
    );
  }
}

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen>
    with SingleTickerProviderStateMixin {
  final StudentStorage storage = StudentStorage();
  final TextEditingController searchController = TextEditingController();

  late TabController tabController;

  List<Student> assetStudents = [];
  List<Student> students = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    loadData();
  }

  // Đọc dữ liệu mẫu và dữ liệu lưu trên thiết bị
  Future<void> loadData() async {
    try {
      final assets = await storage.loadAssetsStudents();
      final local = await storage.loadStudents();

      if (!mounted) return;

      setState(() {
        assetStudents = assets;
        students = local;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Không thể tải dữ liệu. Hãy kiểm tra JSON.';
      });
    }
  }

  // Thêm hoặc sửa sinh viên
  Future<void> showStudentDialog({Student? student}) async {
    final nameController = TextEditingController(
      text: student?.name ?? '',
    );
    final majorController = TextEditingController(
      text: student?.major ?? '',
    );
    final ageController = TextEditingController(
      text: student == null ? '' : student.age.toString(),
    );

    final formKey = GlobalKey<FormState>();

    final result = await showDialog<Student>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(student == null ? 'Add Student' : 'Edit Student'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter student name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: majorController,
                    decoration: const InputDecoration(labelText: 'Major'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter major';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final age = int.tryParse(value ?? '');
                      if (age == null || age < 1 || age > 120) {
                        return 'Enter a valid age';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;

                Navigator.pop(
                  dialogContext,
                  Student(
                    id: student?.id ?? 0,
                    name: nameController.text.trim(),
                    major: majorController.text.trim(),
                    age: int.parse(ageController.text),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    majorController.dispose();
    ageController.dispose();

    if (result == null || !mounted) return;

    final oldStudents = List<Student>.from(students);

    setState(() {
      if (student == null) {
        int newId = 1;

        for (final item in students) {
          if (item.id >= newId) {
            newId = item.id + 1;
          }
        }

        students.add(
          Student(
            id: newId,
            name: result.name,
            major: result.major,
            age: result.age,
          ),
        );
      } else {
        final index = students.indexWhere(
              (item) => item.id == student.id,
        );

        if (index != -1) {
          students[index] = result;
        }
      }
    });

    try {
      await storage.saveStudents(students);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            student == null ? 'Student added!' : 'Student updated!',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        students = oldStudents;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save data.')),
      );
    }
  }

  // Xóa sinh viên sau khi xác nhận
  Future<void> deleteStudent(Student student) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Student'),
          content: Text('Delete ${student.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) return;

    final oldStudents = List<Student>.from(students);

    setState(() {
      students.removeWhere((item) => item.id == student.id);
    });

    try {
      await storage.saveStudents(students);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student deleted!')),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        students = oldStudents;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete student.')),
      );
    }
  }

  // Lọc sinh viên theo tên hoặc chuyên ngành
  List<Student> get filteredStudents {
    final keyword = searchController.text.toLowerCase().trim();

    return students.where((student) {
      return student.name.toLowerCase().contains(keyword) ||
          student.major.toLowerCase().contains(keyword);
    }).toList();
  }

  // Giao diện cho một sinh viên
  Widget buildStudentTile(Student student, {bool editable = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(child: Text('${student.id}')),
        title: Text(
          student.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${student.major}\nAge: ${student.age}'),
        isThreeLine: true,
        trailing: editable
            ? PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              showStudentDialog(student: student);
            } else if (value == 'delete') {
              deleteStudent(student);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9 - Student Manager'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(icon: Icon(Icons.folder_open), text: 'Assets JSON'),
            Tab(icon: Icon(Icons.storage), text: 'Local CRUD'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage!),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                loadData();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : TabBarView(
        controller: tabController,
        children: [
          // Lab 9.1: Đọc JSON từ assets
          assetStudents.isEmpty
              ? const Center(child: Text('No asset data found.'))
              : ListView.builder(
            itemCount: assetStudents.length,
            itemBuilder: (context, index) {
              return buildStudentTile(
                assetStudents[index],
              );
            },
          ),

          // Lab 9.2 và 9.3: File local + CRUD
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search students',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {
                        searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              Expanded(
                child: filteredStudents.isEmpty
                    ? const Center(child: Text('No students found.'))
                    : ListView.builder(
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    return buildStudentTile(
                      filteredStudents[index],
                      editable: true,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: tabController,
        builder: (context, child) {
          if (tabController.index == 0) {
            return const SizedBox.shrink();
          }

          return FloatingActionButton(
            onPressed: () => showStudentDialog(),
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
