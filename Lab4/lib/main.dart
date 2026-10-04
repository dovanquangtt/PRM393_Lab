import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// =====================================================
// MAIN APP
// =====================================================
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),

      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),

      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,

      home: HomePage(
        darkMode: darkMode,
        changeTheme: (value) {
          setState(() {
            darkMode = value;
          });
        },
      ),
    );
  }
}

// =====================================================
// HOME PAGE
// =====================================================
class HomePage extends StatelessWidget {
  final bool darkMode;
  final Function(bool) changeTheme;

  const HomePage({
    super.key,
    required this.darkMode,
    required this.changeTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4 - Flutter UI Fundamentals'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          menu(context, 'Exercise 1 - Core Widgets', const Exercise1()),
          menu(context, 'Exercise 2 - Input Controls', const Exercise2()),
          menu(context, 'Exercise 3 - Layout Demo', const Exercise3()),

          Card(
            child: ListTile(
              title: const Text('Exercise 4 - App Structure & Theme'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Exercise4(
                      darkMode: darkMode,
                      changeTheme: changeTheme,
                    ),
                  ),
                );
              },
            ),
          ),

          menu(context, 'Exercise 5 - Common UI Fixes', const Exercise5()),
        ],
      ),
    );
  }

  Widget menu(BuildContext context, String title, Widget page) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      ),
    );
  }
}

// =====================================================
// EXERCISE 1
// Text, Image, Icon, Card, ListTile
// =====================================================
class Exercise1 extends StatelessWidget {
  const Exercise1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 1 - Core Widgets'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Flutter UI',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Icon(
                Icons.movie,
                size: 60,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 20),

            Image.network(
              'https://picsum.photos/600/300',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,

              // Nếu mất mạng vẫn không crash
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 200,
                  child: Center(
                    child: Icon(Icons.broken_image, size: 60),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            const Card(
              child: ListTile(
                leading: Icon(Icons.star),
                title: Text('Movie Item'),
                subtitle: Text(
                  'This is a sample ListTile inside a Card.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// EXERCISE 2
// Slider, Switch, RadioListTile, DatePicker
// =====================================================
class Exercise2 extends StatefulWidget {
  const Exercise2({super.key});

  @override
  State<Exercise2> createState() => _Exercise2State();
}

class _Exercise2State extends State<Exercise2> {
  double rating = 50;
  bool active = false;
  String? genre;
  DateTime? date;

  Future<void> pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (result != null) {
      setState(() {
        date = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2 - Input Controls'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slider
            const Text(
              'Rating (Slider)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Slider(
              value: rating,
              min: 0,
              max: 100,
              onChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),

            Text('Current value: ${rating.toInt()}'),

            const SizedBox(height: 20),

            // Switch
            const Text(
              'Active (Switch)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SwitchListTile(
              title: const Text('Is movie active?'),
              value: active,
              onChanged: (value) {
                setState(() {
                  active = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // RadioListTile
            const Text(
              'Genre (RadioListTile)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            RadioListTile<String>(
              title: const Text('Action'),
              value: 'Action',
              groupValue: genre,
              onChanged: (value) {
                setState(() {
                  genre = value;
                });
              },
            ),

            RadioListTile<String>(
              title: const Text('Comedy'),
              value: 'Comedy',
              groupValue: genre,
              onChanged: (value) {
                setState(() {
                  genre = value;
                });
              },
            ),

            Text('Selected genre: ${genre ?? "None"}'),

            const SizedBox(height: 20),

            // DatePicker
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: pickDate,
                child: const Text('Open Date Picker'),
              ),
            ),

            if (date != null)
              Center(
                child: Text(
                  'Date: ${date!.day}/${date!.month}/${date!.year}',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// EXERCISE 3
// Column, Row, Padding, ListView
// =====================================================
class Exercise3 extends StatelessWidget {
  const Exercise3({super.key});

  final List<String> movies = const [
    'Avatar',
    'Inception',
    'Interstellar',
    'Joker',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3 - Layout Demo'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            const Text(
              'Now Playing',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Expanded giúp ListView chạy trong Column
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,

                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(movies[index][0]),
                      ),
                      title: Text(movies[index]),
                      subtitle: const Text('Sample description'),
                    ),
                  );
                },
              ),
            ),

            // Row
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.home),
                Icon(Icons.movie),
                Icon(Icons.favorite),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// EXERCISE 4
// Scaffold, AppBar, Body, FAB, Theme
// =====================================================
class Exercise4 extends StatefulWidget {
  final bool darkMode;
  final Function(bool) changeTheme;

  const Exercise4({
    super.key,
    required this.darkMode,
    required this.changeTheme,
  });

  @override
  State<Exercise4> createState() => _Exercise4State();
}

class _Exercise4State extends State<Exercise4> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: const Text('Exercise 4 - App Structure'),

        actions: [
          const Center(
            child: Text('Dark'),
          ),

          Switch(
            value: widget.darkMode,
            onChanged: widget.changeTheme,
          ),
        ],
      ),

      // Body
      body: Center(
        child: Text(
          'This is a simple screen with theme toggle.\n\n'
              'FAB pressed: $count times',
          textAlign: TextAlign.center,
        ),
      ),

      // FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            count++;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// =====================================================
// EXERCISE 5
// Fix common UI errors
// =====================================================
class Exercise5 extends StatefulWidget {
  const Exercise5({super.key});

  @override
  State<Exercise5> createState() => _Exercise5State();
}

class _Exercise5State extends State<Exercise5> {
  int count = 0;
  DateTime? date;

  final List<String> movies = [
    'Movie A',
    'Movie B',
    'Movie C',
    'Movie D',
  ];

  Future<void> pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (result != null) {
      setState(() {
        date = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 - Common UI Fixes'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Correct ListView inside Column using Expanded',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // FIX 1: ListView trong Column dùng Expanded
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.movie),
                    title: Text(movies[index]),
                  );
                },
              ),
            ),

            // FIX 3: dùng setState để cập nhật UI
            Text('Counter: $count'),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  count++;
                });
              },
              child: const Text('Test setState'),
            ),

            const SizedBox(height: 8),

            // FIX 4: DatePicker dùng context hợp lệ
            ElevatedButton(
              onPressed: pickDate,
              child: const Text('Test DatePicker'),
            ),

            if (date != null)
              Text(
                'Date: ${date!.day}/${date!.month}/${date!.year}',
              ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}