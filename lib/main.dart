import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Determine the platform brightness
    Brightness brightness = MediaQuery.of(context).platformBrightness;

    // Set the background color based on the system theme
    Color backgroundColor =
        brightness == Brightness.light ? Colors.white : Colors.black;
    Color fontColor =
        brightness == Brightness.light ? Colors.black54 : Colors.white;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: backgroundColor,
          iconTheme: IconThemeData(color: fontColor),
          textTheme: TextTheme(bodyMedium: TextStyle(color: fontColor))),
      home: const Weather(),
    );
  }
}
