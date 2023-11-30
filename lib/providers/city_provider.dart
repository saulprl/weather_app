import 'package:flutter/material.dart';

class CityProvider with ChangeNotifier {
  int _cityIndex = 0;
  final List<String> cities = [
    "Hermosillo",
    "Lima",
    "Londres",
    "Seúl",
    "Ciudad de México",
  ];

  int get city => _cityIndex;

  set city(int value) {
    _cityIndex = value;
    notifyListeners();
  }
}
