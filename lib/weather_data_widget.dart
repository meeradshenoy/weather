import 'package:flutter/material.dart';

class WeatherDataWidget extends StatelessWidget {
  String imageUrl; // The URL of the weather-related image
  String title; // The title or label for the weather data
  String value; // The actual value of the weather data

  // Constructor to initialize the WeatherDataWidget
  WeatherDataWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    // A row containing an image, and a column with text information
    return Row(
      children: [
        // Display the weather-related image
        Image.asset(
          imageUrl,
          height: 50,
        ),
        // Display weather data in a column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the title or label with specific styling
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.5),
              ),
            ),
            // Display the actual value of the weather data with specific styling
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }
}
