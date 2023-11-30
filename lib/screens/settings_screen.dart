import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/city_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<String> cities = [
    "Hermosillo",
    "Lima",
    "Londres",
    "Seúl",
    "Ciudad de México",
  ];

  @override
  Widget build(BuildContext context) {
    final cities = Provider.of<CityProvider>(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: ListView.builder(
          itemCount: cities.cities.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(cities.cities[index]),
              onTap: () {
                print("Tapped on ${cities.cities[index]}");
                cities.city = index;
              },
            );
          },
        ),
      ),
    );
  }
}
