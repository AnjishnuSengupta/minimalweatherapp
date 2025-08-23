class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final int weatherCode;
  final double humidity;
  final double windSpeed;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.weatherCode,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String cityName) {
    // Open-Meteo API response structure
    final current = json['current'];

    return Weather(
      cityName: cityName,
      temperature: current['temperature_2m'].toDouble(),
      mainCondition: _getWeatherCondition(current['weather_code']),
      weatherCode: current['weather_code'],
      humidity: current['relative_humidity_2m'].toDouble(),
      windSpeed: current['wind_speed_10m'].toDouble(),
    );
  }

  // Convert WMO weather codes to readable conditions
  static String _getWeatherCondition(int code) {
    switch (code) {
      case 0:
        return 'Clear';
      case 1:
      case 2:
      case 3:
        return 'Partly Cloudy';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 56:
      case 57:
        return 'Freezing Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rainy';
      case 66:
      case 67:
        return 'Freezing Rain';
      case 71:
      case 73:
      case 75:
        return 'Snowy';
      case 77:
        return 'Snow Grains';
      case 80:
      case 81:
      case 82:
        return 'Rain Showers';
      case 85:
      case 86:
        return 'Snow Showers';
      case 95:
        return 'Thunderstorm';
      case 96:
      case 99:
        return 'Thunderstorm with Hail';
      default:
        return 'Unknown';
    }
  }
}
