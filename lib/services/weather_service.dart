import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.weatherapi.com/v1';
  final String apiKey;

  WeatherService() : apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';

  Future<Weather?> getWeatherByCity(String cityName) async {
    if (apiKey.isEmpty) {
      throw Exception(
        'Weather API key not found. Please add WEATHER_API_KEY to .env file',
      );
    }

    final url = '$BASE_URL/current.json?key=$apiKey&q=$cityName&aqi=no';
    print('🌐 API Call (City): $url');

    try {
      final response = await http.get(Uri.parse(url));
      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('✅ Weather data received for: ${jsonData['location']['name']}');
        return Weather.fromJson(jsonData);
      } else {
        final errorData = jsonDecode(response.body);
        print('❌ API Error: ${errorData['error']['message']}');
        throw Exception(
          'Failed to load weather data: ${errorData['error']['message']}',
        );
      }
    } catch (e) {
      print('❌ Exception in API call: $e');
      throw Exception('Failed to load weather data: $e');
    }
  }

  Future<Weather?> getWeatherByCoordinates(
    double latitude,
    double longitude,
  ) async {
    if (apiKey.isEmpty) {
      throw Exception(
        'Weather API key not found. Please add WEATHER_API_KEY to .env file',
      );
    }

    final url =
        '$BASE_URL/current.json?key=$apiKey&q=$latitude,$longitude&aqi=no';
    print('🌐 API Call (Coordinates): $url');

    try {
      final response = await http.get(Uri.parse(url));
      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(
          '✅ Weather data received for: ${jsonData['location']['name']} (${jsonData['location']['lat']}, ${jsonData['location']['lon']})',
        );
        return Weather.fromJson(jsonData);
      } else {
        final errorData = jsonDecode(response.body);
        print('❌ API Error: ${errorData['error']['message']}');
        throw Exception(
          'Failed to load weather data: ${errorData['error']['message']}',
        );
      }
    } catch (e) {
      print('❌ Exception in API call: $e');
      throw Exception('Failed to load weather data: $e');
    }
  }

  Future<String> getCurrentCity() async {
    print('🌍 Starting location detection...');

    // For web platform, try IP-based location first
    if (kIsWeb) {
      print('🌐 Running on web, trying IP-based location...');
      try {
        // Use WeatherAPI's auto:ip feature for web
        final weather = await getWeatherByCity('auto:ip');
        if (weather != null) {
          print('✅ IP-based location successful: ${weather.cityName}');
          return weather.cityName;
        }
      } catch (e) {
        print('❌ IP-based location failed: $e');
      }
    }

    try {
      // First check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('❌ Location services are disabled');
        return kIsWeb ? 'auto:ip' : 'London';
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      print('📍 Current permission: $permission');

      if (permission == LocationPermission.denied) {
        print('🔒 Permission denied, requesting...');
        permission = await Geolocator.requestPermission();
        print('📍 New permission after request: $permission');
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        print('❌ Permission not granted');
        return kIsWeb ? 'auto:ip' : 'London';
      }

      print('✅ Permission granted, getting position...');

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 10),
      ).timeout(Duration(seconds: 15));

      print('📍 Got position: ${position.latitude}, ${position.longitude}');

      // Return coordinates directly - WeatherAPI handles location detection
      String coords = '${position.latitude},${position.longitude}';
      print('🔄 Using coordinates: $coords');
      return coords;
    } catch (e) {
      print('❌ Location detection failed: $e');
      return kIsWeb ? 'auto:ip' : 'London';
    }
  }

  // Test method for debugging location issues
  Future<void> testLocation() async {
    print('🧪 Testing location services...');

    // Test 1: Service availability
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print('1️⃣ Location services enabled: $serviceEnabled');

    // Test 2: Permission status
    LocationPermission permission = await Geolocator.checkPermission();
    print('2️⃣ Permission status: $permission');

    // Test 3: Try to get position
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 5),
      );
      print('3️⃣ Position: ${position.latitude}, ${position.longitude}');

      // Test 4: API call with coordinates
      try {
        final weather = await getWeatherByCoordinates(
          position.latitude,
          position.longitude,
        );
        print('4️⃣ Weather API response: ${weather?.cityName}');
      } catch (e) {
        print('4️⃣ Weather API failed: $e');
      }
    } catch (e) {
      print('3️⃣ Position failed: $e');

      // Test 5: Try with manual coordinates (New York City)
      print('5️⃣ Testing with manual coordinates (NYC)...');
      try {
        final weather = await getWeatherByCoordinates(40.7128, -74.0060);
        print('5️⃣ Manual coordinates worked: ${weather?.cityName}');
      } catch (e) {
        print('5️⃣ Manual coordinates failed: $e');
      }
    }
  }

  Future<Weather?> getCurrentWeather() async {
    print('🌤️ Getting current weather...');
    final cityName = await getCurrentCity();
    print('🏙️ City/Location resolved to: $cityName');

    // If cityName contains coordinates (comma), use coordinate-based API
    if (cityName.contains(',')) {
      print('📍 Using coordinate-based API');
      final coords = cityName.split(',');
      if (coords.length == 2) {
        final lat = double.tryParse(coords[0]);
        final lon = double.tryParse(coords[1]);
        if (lat != null && lon != null) {
          print('🌍 Calling API with coordinates: $lat, $lon');
          return await getWeatherByCoordinates(lat, lon);
        }
      }
    }

    // Otherwise use city name
    print('🏙️ Calling API with city name: $cityName');
    return await getWeatherByCity(cityName);
  }
}
