import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.open-meteo.com/v1/forecast';

  WeatherService(); // No API key needed for Open-Meteo

  Future<Weather?> getWeatherByCoordinates(
    double latitude,
    double longitude,
    String cityName,
  ) async {
    final url =
        '$BASE_URL?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m&timezone=auto';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Weather.fromJson(jsonData, cityName);
    } else {
      throw Exception(
        'Failed to load weather data. Status: ${response.statusCode}',
      );
    }
  }

  Future<Weather?> getWeather(String cityName) async {
    // For backward compatibility, we'll get coordinates for the city first
    try {
      List<Location> locations = await locationFromAddress(cityName);
      if (locations.isNotEmpty) {
        final location = locations.first;
        return await getWeatherByCoordinates(
          location.latitude,
          location.longitude,
          cityName,
        );
      } else {
        throw Exception('City not found: $cityName');
      }
    } catch (e) {
      throw Exception(
        'Failed to get coordinates for city: $cityName. Error: $e',
      );
    }
  }

  Future<String> getCurrentCity() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        return 'Kolkata'; // Fallback to your city
      }

      if (permission == LocationPermission.denied) {
        return 'Kolkata'; // Fallback to your city
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      // Get place information and extract main city
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];

          // Smart city mapping - use major cities that Open-Meteo recognizes
          String cityName = 'Unknown';

          // For West Bengal/Kolkata area
          if (place.administrativeArea?.toLowerCase().contains('west bengal') ==
                  true ||
              place.locality?.toLowerCase().contains('kolkata') == true ||
              place.subAdministrativeArea?.toLowerCase().contains(
                    'north 24 parganas',
                  ) ==
                  true) {
            cityName = 'Kolkata';
          }
          // For Delhi area
          else if (place.administrativeArea?.toLowerCase().contains('delhi') ==
                  true ||
              place.locality?.toLowerCase().contains('delhi') == true) {
            cityName = 'New Delhi';
          }
          // For Mumbai area
          else if (place.administrativeArea?.toLowerCase().contains(
                    'maharashtra',
                  ) ==
                  true &&
              (place.locality?.toLowerCase().contains('mumbai') == true ||
                  place.subAdministrativeArea?.toLowerCase().contains(
                        'mumbai',
                      ) ==
                      true)) {
            cityName = 'Mumbai';
          }
          // For Bangalore area
          else if (place.administrativeArea?.toLowerCase().contains(
                    'karnataka',
                  ) ==
                  true &&
              (place.locality?.toLowerCase().contains('bangalore') == true ||
                  place.locality?.toLowerCase().contains('bengaluru') ==
                      true)) {
            cityName = 'Bangalore';
          }
          // For Chennai area
          else if (place.administrativeArea?.toLowerCase().contains(
                    'tamil nadu',
                  ) ==
                  true &&
              place.locality?.toLowerCase().contains('chennai') == true) {
            cityName = 'Chennai';
          }
          // Generic fallback to locality or administrative area
          else if (place.locality != null && place.locality!.isNotEmpty) {
            cityName = place.locality!;
          } else if (place.administrativeArea != null &&
              place.administrativeArea!.isNotEmpty) {
            cityName = place.administrativeArea!;
          }

          return cityName;
        }
      } catch (e) {
        // Could not get place information, use coordinates
      }

      return 'Kolkata'; // Default fallback
    } catch (e) {
      return 'Kolkata'; // Default fallback
    }
  }

  Future<Weather?> getCurrentWeather() async {
    final cityName = await getCurrentCity();
    return await getWeather(cityName);
  }
}
