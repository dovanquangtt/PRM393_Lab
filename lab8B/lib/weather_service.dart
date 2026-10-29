
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather.dart';

class WeatherService {
  final http.Client client;

  WeatherService({http.Client? client})
      : client = client ?? http.Client();

  // Lấy thời tiết theo tên thành phố
  Future<Weather> fetchWeather(String city) async {
    if (city.trim().isEmpty) {
      throw Exception('Vui lòng nhập tên thành phố.');
    }

    try {
      // Bước 1: Tìm tọa độ thành phố
      final geoUrl = Uri.https(
        'geocoding-api.open-meteo.com',
        '/v1/search',
        {
          'name': city.trim(),
          'count': '1',
          'language': 'en',
          'format': 'json',
        },
      );

      final geoResponse = await client
          .get(geoUrl)
          .timeout(const Duration(seconds: 15));

      if (geoResponse.statusCode != 200) {
        throw Exception('Không thể tìm thành phố.');
      }

      final geoData =
      json.decode(geoResponse.body) as Map<String, dynamic>;

      final results = geoData['results'] as List<dynamic>?;

      if (results == null || results.isEmpty) {
        throw Exception('Không tìm thấy thành phố này.');
      }

      final location = results.first as Map<String, dynamic>;
      final latitude = location['latitude'] as num;
      final longitude = location['longitude'] as num;
      final cityName = location['name'] as String;

      // Bước 2: Lấy thời tiết theo tọa độ
      final weatherUrl = Uri.https(
        'api.open-meteo.com',
        '/v1/forecast',
        {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m',
          'timezone': 'auto',
        },
      );

      final weatherResponse = await client
          .get(weatherUrl)
          .timeout(const Duration(seconds: 15));

      if (weatherResponse.statusCode != 200) {
        throw Exception('Không thể tải dữ liệu thời tiết.');
      }

      final weatherData =
      json.decode(weatherResponse.body) as Map<String, dynamic>;

      final current =
      weatherData['current'] as Map<String, dynamic>?;

      if (current == null) {
        throw Exception('Dữ liệu thời tiết không hợp lệ.');
      }

      return Weather.fromJson(cityName, current);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Đã xảy ra lỗi khi xử lý dữ liệu.');
    }
  }

  // Đóng HTTP client
  void dispose() {
    client.close();
  }
}
