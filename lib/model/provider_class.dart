import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductProvider extends ChangeNotifier {
  dynamic _selectedIndex = {};
  List<dynamic> _products = [];

  dynamic get selectedIndex => _selectedIndex;
  List<dynamic> get products => _products;

  Future<void> loadProductsFromAPI() async {
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        List<dynamic> products = json.decode(response.body);
        _products = products;
        notifyListeners();
      } else {
        print('Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error loading products: $error');
    }
  }

  void loadProducts(List<dynamic> products) {
    _products = products;
    notifyListeners();
  }

  void setSelectedIndex(dynamic product) {
    if (_selectedIndex == product) {
      _selectedIndex = {};
    } else {
      _selectedIndex = product;
    }
    notifyListeners();
  }
}
