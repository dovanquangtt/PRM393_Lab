import 'dart:async';
import 'dart:convert';

Future<void> main() async {
  await exercise1();
  await exercise2();
  exercise3();

  // Chờ event queue của Exercise 3 chạy xong
  await Future.delayed(Duration(milliseconds: 100));

  await exercise4();
  exercise5();
}

// ================= EXERCISE 1 =================
// Product Model & Repository
Future<void> exercise1() async {
  print('\n--- Exercise 1 ---');

  ProductRepository repo = ProductRepository();

  // Lắng nghe sản phẩm mới
  repo.liveAdded().listen((product) {
    print('New product: $product');
  });

  // Lấy danh sách sản phẩm
  List<Product> products = await repo.getAll();

  for (Product product in products) {
    print(product);
  }

  repo.add(Product(3, 'Lily', 150.0));

  await Future.delayed(Duration(milliseconds: 100));
}

class Product {
  int id;
  String name;
  double price;

  Product(this.id, this.name, this.price);

  @override
  String toString() {
    return '$id - $name - $price';
  }
}

class ProductRepository {
  List<Product> products = [
    Product(1, 'Rose', 100.0),
    Product(2, 'Tulip', 120.0),
  ];

  // Broadcast Stream
  StreamController<Product> controller =
  StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {
    return products;
  }

  Stream<Product> liveAdded() {
    return controller.stream;
  }

  void add(Product product) {
    products.add(product);
    controller.add(product);
  }
}

// ================= EXERCISE 2 =================
// User Repository with JSON
Future<void> exercise2() async {
  print('\n--- Exercise 2 ---');

  UserRepository repo = UserRepository();

  List<User> users = await repo.getUsers();

  for (User user in users) {
    print('${user.name} - ${user.email}');
  }
}

class User {
  String name;
  String email;

  User(this.name, this.email);

  // Chuyển JSON thành User
  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];
}

class UserRepository {
  Future<List<User>> getUsers() async {
    // Giả lập JSON từ API
    String jsonData = '''
    [
      {"name":"Quang","email":"quang@gmail.com"},
      {"name":"Nam","email":"nam@gmail.com"}
    ]
    ''';

    List data = jsonDecode(jsonData);

    return data.map((item) => User.fromJson(item)).toList();
  }
}

// ================= EXERCISE 3 =================
// Async + Microtask
void exercise3() {
  print('\n--- Exercise 3 ---');

  print('Start');

  // Microtask queue
  scheduleMicrotask(() {
    print('Microtask');
  });

  // Event queue
  Future(() {
    print('Future');
  });

  print('End');
}

// ================= EXERCISE 4 =================
// Stream Transformation
Future<void> exercise4() async {
  print('\n--- Exercise 4 ---');

  Stream<int> numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

  // Bình phương rồi lọc số chẵn
  Stream<int> result = numbers
      .map((number) => number * number)
      .where((number) => number % 2 == 0);

  await for (int number in result) {
    print(number);
  }
}

// ================= EXERCISE 5 =================
// Factory Constructor & Singleton
void exercise5() {
  print('\n--- Exercise 5 ---');

  Settings a = Settings();
  Settings b = Settings();

  // Kiểm tra 2 biến có cùng object không
  print(identical(a, b));
}

class Settings {
  // Tạo một object duy nhất
  static final Settings _instance = Settings._private();

  // Private constructor
  Settings._private();

  // Luôn trả về object đã tạo
  factory Settings() {
    return _instance;
  }
}