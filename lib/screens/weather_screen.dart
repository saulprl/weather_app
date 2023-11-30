import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/city_provider.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final List<String> _icono = [
    "assets/cloudy.png",
    "assets/sunny.png",
    "assets/windy.png",
    "assets/stormy.png",
    "assets/rainy.png",
  ];

  int _idx = 0;

  String _temperatura = "Es necesario actualizar";
  final _random = Random();
  DateTime _lastUpdate = DateTime.now();
  var _isLoading = false;
  final _location = "Hermosillo";
  String? responseLocation;
  String? responseIcon;

  Future<Map<String, dynamic>> _fetchWeather() async {
    final res = await http.post(
      Uri.https(
        "api.weatherapi.com",
        "/v1/current.json",
        {"key": "a44a2473be8f4df6bab203625231311", "q": _location},
      ),
    );

    final data = json.decode(res.body) as Map<String, dynamic>;

    return data;
  }

  Future<void> _actualiza() async {
    setState(() {
      _isLoading = true;
    });

    if (DateTime.now().isBefore(_lastUpdate.add(const Duration(seconds: 5)))) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final weatherData = await _fetchWeather();
    setState(() {
      _temperatura = "${weatherData["current"]["temp_c"]} °C";
      _idx = _random.nextInt(_icono.length);
      _lastUpdate = DateTime.now();
      responseLocation =
          "${weatherData["location"]["name"]}, ${weatherData["location"]["region"]}";
      responseIcon = weatherData["current"]["condition"]["icon"];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cities = Provider.of<CityProvider>(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the blank spaces
            Text(
              cities.cities[cities.city],
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                _temperatura,
                style: const TextStyle(fontSize: 30, letterSpacing: 2.0),
              ),
            ),
            const SizedBox(height: 16),

            // Display the first image
            responseIcon != null
                ? Image.network("https:$responseIcon", width: 160)
                : Image.asset(_icono[_idx], height: 160),

            const SizedBox(height: 16),
            SizedBox(
              width: 120,
              child: FilledButton(
                onPressed: _actualiza,
                child: const Text('Actualiza'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Última actualización: ${DateFormat("yyyy/MM/dd HH:mm:ss").format(_lastUpdate)}",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (_isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
