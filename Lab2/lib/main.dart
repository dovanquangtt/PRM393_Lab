Future<void> main() async {
  exercise1();
  exercise2();
  exercise3();
  exercise4();
  await exercise5();
}

// ================= EXERCISE 1 =================
// Basic Syntax & Data Types
void exercise1() {
  print('\n--- Exercise 1 ---');

  int age = 20;
  double score = 8.5;
  String name = 'Do Van Quang';
  bool isStudent = true;

  print('Name: $name');
  print('Age: $age');
  print('Score: $score');
  print('Student: $isStudent');
  print('Next year: ${age + 1}');
}

// ================= EXERCISE 2 =================
// Collections & Operators
void exercise2() {
  print('\n--- Exercise 2 ---');

  // List
  List<int> numbers = [10, 20, 30];
  numbers.add(40);
  numbers.remove(20);

  print('List: $numbers');
  print('First number: ${numbers[0]}');

  // Operators
  int a = 10;
  int b = 5;

  print('a + b = ${a + b}');
  print('a - b = ${a - b}');
  print('a == b: ${a == b}');
  print('a > b && b > 0: ${a > b && b > 0}');
  print(a > b ? 'a is greater' : 'b is greater');

  // Set
  Set<int> set = {1, 2, 2, 3};
  print('Set: $set');

  // Map
  Map<String, dynamic> student = {
    'name': 'Quang',
    'score': 8.5
  };

  print('Student name: ${student['name']}');
}

// ================= EXERCISE 3 =================
// Control Flow & Functions
void exercise3() {
  print('\n--- Exercise 3 ---');

  double score = 8;

  // if / else
  if (score >= 5) {
    print('Pass');
  } else {
    print('Fail');
  }

  // switch
  int day = 2;

  switch (day) {
    case 1:
      print('Monday');
      break;
    case 2:
      print('Tuesday');
      break;
    default:
      print('Other day');
  }

  List<int> numbers = [1, 2, 3];

  // for
  for (int i = 0; i < numbers.length; i++) {
    print(numbers[i]);
  }

  // for-in
  for (int number in numbers) {
    print(number);
  }

  // forEach
  numbers.forEach((number) {
    print(number);
  });

  print('Sum: ${sum(5, 3)}');
  print('Multiply: ${multiply(5, 3)}');
}

// Normal function
int sum(int a, int b) {
  return a + b;
}

// Arrow function
int multiply(int a, int b) => a * b;

// ================= EXERCISE 4 =================
// OOP
void exercise4() {
  print('\n--- Exercise 4 ---');

  Car car1 = Car('Toyota');
  car1.showInfo();

  Car car2 = Car.withBrand('Honda');
  car2.showInfo();

  ElectricCar car3 = ElectricCar('Tesla');
  car3.showInfo();
}

class Car {
  String brand;

  // Constructor
  Car(this.brand);

  // Named constructor
  Car.withBrand(this.brand);

  void showInfo() {
    print('Car: $brand');
  }
}

class ElectricCar extends Car {
  ElectricCar(String brand) : super(brand);

  @override
  void showInfo() {
    print('Electric Car: $brand');
  }
}

// ================= EXERCISE 5 =================
// Async, Future, Null Safety & Stream
Future<void> exercise5() async {
  print('\n--- Exercise 5 ---');

  // Future + await
  String data = await loadData();
  print(data);

  // Null Safety
  String? nickname;

  print(nickname ?? 'No nickname');

  nickname = 'Quang';
  print(nickname!.length);

  // Stream
  Stream<int> stream = Stream.fromIterable([1, 2, 3]);

  await for (int number in stream) {
    print(number);
  }
}

Future<String> loadData() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Data loaded';
}