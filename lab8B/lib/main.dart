
import 'package:flutter/material.dart';
import 'weather.dart';
import 'weather_service.dart';

void main() {
  runApp(const MyApp());
}

// Cấu hình ứng dụng
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Companion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const WeatherScreen(),
    );
  }
}

// Màn hình thời tiết
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService service = WeatherService();

  final TextEditingController cityController =
  TextEditingController(text: 'Hanoi');

  late Future<Weather> weatherFuture;

  @override
  void initState() {
    super.initState();
    weatherFuture = service.fetchWeather('Hanoi');
  }

  // Tìm kiếm thời tiết
  void searchWeather() {
    final city = cityController.text.trim();

    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tên thành phố.'),
        ),
      );
      return;
    }

    setState(() {
      weatherFuture = service.fetchWeather(city);
    });
  }

  @override
  void dispose() {
    cityController.dispose();
    service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Companion'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Weather>(
        future: weatherFuture,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Không thể tải thời tiết!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Kiểm tra mạng hoặc tên thành phố.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: searchWeather,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Data
          final weather = snapshot.data;

          if (weather == null) {
            return const Center(
              child: Text('Không có dữ liệu thời tiết.'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Ô tìm kiếm thành phố
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: 'Tên thành phố',
                        hintText: 'Ví dụ: Hanoi, Tokyo',
                        prefixIcon: Icon(Icons.location_city),
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => searchWeather(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: searchWeather,
                    icon: const Icon(Icons.search),
                    tooltip: 'Tìm thời tiết',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Thời tiết chính
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.wb_cloudy,
                        size: 64,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weather.city,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${weather.temperature.toStringAsFixed(1)} °C',
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        weather.description,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Weather Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Thông số thời tiết
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.thermostat),
                      title: const Text('Cảm giác như'),
                      trailing: Text(
                        '${weather.feelsLike.toStringAsFixed(1)} °C',
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.water_drop),
                      title: const Text('Độ ẩm'),
                      trailing: Text('${weather.humidity}%'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.air),
                      title: const Text('Tốc độ gió'),
                      trailing: Text(
                        '${weather.windSpeed.toStringAsFixed(1)} km/h',
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.umbrella),
                      title: const Text('Lượng mưa'),
                      trailing: Text(
                        '${weather.precipitation} mm',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Gợi ý thời tiết
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb,
                        color: Colors.orange,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gợi ý cho bạn',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(weather.recommendation),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Data provided by Open-Meteo',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          );
        },
      ),
    );
  }
}
