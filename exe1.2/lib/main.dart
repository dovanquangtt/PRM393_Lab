abstract class Employee {
  String name;

  Employee(this.name);

  void work();
}

// TODO 1: Khai báo mixin CheckInAbility
mixin CheckInAbility on Employee {
  void checkIn() {
    print("$name đã điểm danh");
  }
}

// TODO 2: Developer kế thừa Employee
class Developer extends Employee with CheckInAbility {
  Developer(String name) : super(name);

  @override
  void work() => print("$name đang viết code.");
}

void main() {
  List<Developer> teamA = [
    Developer("An"),
    Developer("Bình"),
  ];

  List<Developer> teamB = [
    Developer("Cường"),
  ];

  // TODO 3: Dùng Spread Operator (...) để gộp 2 danh sách
  List<Developer> allStaff = [
    ...teamA,
    ...teamB,
  ];

  // TODO 4: Gọi checkIn() cho tất cả nhân viên
  for (var employee in allStaff) {
    employee.checkIn();
  }
}