class WeatherData {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final int sunrise;
  final int sunset;
  final double minTemp;
  final double maxTemp;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.sunrise,
    required this.sunset,
    required this.minTemp,
    required this.maxTemp,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
        cityName: json['name'],
        temperature: json['main']['temp'].toDouble(),
        mainCondition: json['weather'][0]['main'],
        sunrise: json['sys']['sunrise'],
        sunset: json['sys']['sunset'],
        minTemp: json['main']['temp_min'].toDouble(),
        maxTemp: json['main']['temp_max'].toDouble());
  }
}
