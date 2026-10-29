
class Weather {
  final String city;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int weatherCode;
  final double precipitation;

  Weather({
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.precipitation,
  });

  // Chuyển JSON thành đối tượng Weather
  factory Weather.fromJson(
      String city,
      Map<String, dynamic> json,
      ) {
    return Weather(
      city: city,
      temperature:
      (json['temperature_2m'] as num).toDouble(),
      feelsLike:
      (json['apparent_temperature'] as num).toDouble(),
      humidity:
      (json['relative_humidity_2m'] as num).toInt(),
      windSpeed:
      (json['wind_speed_10m'] as num).toDouble(),
      weatherCode:
      (json['weather_code'] as num).toInt(),
      precipitation:
      (json['precipitation'] as num).toDouble(),
    );
  }

  // Mô tả thời tiết theo mã WMO
  String get description {
    if (weatherCode == 0) {
      return 'Trời quang đãng';
    } else if (weatherCode <= 3) {
      return 'Trời có mây';
    } else if (weatherCode <= 48) {
      return 'Có sương mù';
    } else if (weatherCode <= 67) {
      return 'Có mưa';
    } else if (weatherCode <= 77) {
      return 'Có tuyết';
    } else if (weatherCode <= 82) {
      return 'Mưa rào';
    } else if (weatherCode <= 86) {
      return 'Tuyết rào';
    } else {
      return 'Có thể có giông';
    }
  }

  // Gợi ý hoạt động theo thời tiết
  String get recommendation {
    if (weatherCode >= 51 && weatherCode <= 67 ||
        weatherCode >= 80 && weatherCode <= 99 ||
        precipitation > 0) {
      return 'Nên mang ô khi ra ngoài.';
    } else if (temperature >= 35) {
      return 'Trời nóng, nên hạn chế hoạt động ngoài trời.';
    } else if (temperature >= 20 && temperature < 30) {
      return 'Thời tiết khá dễ chịu để đi dạo.';
    } else if (temperature < 15) {
      return 'Trời lạnh, hãy mặc đủ ấm.';
    } else {
      return 'Hãy kiểm tra điều kiện thực tế trước khi ra ngoài.';
    }
  }
}
