import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather/weather_model.dart'; // Assuming WeatherData is defined in weather_model.dart

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";

  final String apiKey;

  // Constructor to initialize WeatherService with an API key
  WeatherService(this.apiKey);

  // Fetch weather data for a specific city using OpenWeatherMap API
  Future<WeatherData> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    // Check if the API request was successful
    if (response.statusCode == 200) {
      // Parse the JSON response and convert it to a WeatherData object
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      // Throw an exception if the API request failed
      throw Exception('Failed to load data');
    }
  }

  // Get the current city based on the device's location
  Future<String> getCurrentCity() async {
    // Check and request location permissions if necessary
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Get the current device position (latitude and longitude)
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Retrieve the city name based on the coordinates using geocoding
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String city = placemarks[0].locality ?? "";

    return city;
  }
}
