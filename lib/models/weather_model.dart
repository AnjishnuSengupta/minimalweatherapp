class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final int weatherCode;
  final double humidity;
  final double windSpeed;
  final double feelsLike;
  final double uvIndex;
  final int cloudCover;
  final double pressure;
  final String iconUrl;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.weatherCode,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.uvIndex,
    required this.cloudCover,
    required this.pressure,
    required this.iconUrl,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final location = json['location'];
    final current = json['current'];
    final condition = current['condition'];

    return Weather(
      cityName: location['name'],
      temperature: current['temp_c'].toDouble(),
      mainCondition: condition['text'],
      weatherCode: condition['code'],
      humidity: current['humidity'].toDouble(),
      windSpeed: current['wind_kph'].toDouble(),
      feelsLike: current['feelslike_c'].toDouble(),
      uvIndex: current['uv'].toDouble(),
      cloudCover: current['cloud'],
      pressure: current['pressure_mb'].toDouble(),
      iconUrl: 'https:${condition['icon']}',
    );
  }
}
