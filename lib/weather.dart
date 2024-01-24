import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/api_keys.dart';
import 'package:weather/weather_data_widget.dart';
import 'package:weather/weather_model.dart';
import 'package:weather/weather_service.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  final _weatherService = WeatherService(ApiKeys.weatherApiKey);
  WeatherData? _weatherData;

  // Fetch weather data based on the current city
  _fetchWeather() async {
    try {
      String city = await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(city);
      print(weather.toString());
      setState(() {
        _weatherData = weather;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Determine the appropriate Lottie animation based on weather conditions
  String getWeatherAnimation(String condition) {
    switch (condition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sun.json';
      default:
        return 'assets/sun.json';
    }
  }

  // Convert timestamp to local time string
  String timestampToLocalTimeString(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    DateTime localTime = dateTime.toLocal();
    int hours = localTime.hour;
    int minutes = localTime.minute;
    String period = (hours < 12) ? 'AM' : 'PM';
    if (hours > 12) {
      hours -= 12;
    } else if (hours == 0) {
      hours = 12;
    }
    return '$hours:${minutes < 10 ? '0$minutes' : '$minutes'} $period';
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            // Background Circles
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.purple),
                ),
                Container(
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.teal),
                ),
              ],
            ),
            // Blur Filter for Background
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 100.0,
                sigmaY: 100.0,
              ),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // Loading Animation
            if (_weatherData == null)
              Center(child: Lottie.asset('assets/loader.json')),
            // Weather Information Display
            if (_weatherData != null)
              Container(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    // Weather Animation
                    Lottie.asset(
                        getWeatherAnimation(_weatherData?.mainCondition ?? "")),
                    const Spacer(),
                    // City Name
                    Text(
                      _weatherData?.cityName.toUpperCase() ?? "Loading",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    // Temperature
                    Text(
                      '${_weatherData?.temperature.round().toString()}°C',
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                    // Weather Condition
                    Text(
                      _weatherData?.mainCondition ?? "",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    // Sunrise and Sunset Information
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      child: Row(
                        children: [
                          WeatherDataWidget(
                              imageUrl: 'assets/sunrise.png',
                              title: 'Sunrise',
                              value: timestampToLocalTimeString(
                                  _weatherData!.sunrise)),
                          const Spacer(),
                          WeatherDataWidget(
                              imageUrl: 'assets/sunset.png',
                              title: 'Sunset',
                              value: timestampToLocalTimeString(
                                  _weatherData!.sunset)),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    // Max and Min Temperature Information
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      child: Row(
                        children: [
                          WeatherDataWidget(
                              imageUrl: 'assets/max_temp.png',
                              title: 'Temp Max',
                              value: '${_weatherData?.maxTemp.toString()}°C'),
                          const Spacer(),
                          WeatherDataWidget(
                              imageUrl: 'assets/min_temp.png',
                              title: 'Temp Min',
                              value: '${_weatherData?.minTemp.toString()}°C'),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
