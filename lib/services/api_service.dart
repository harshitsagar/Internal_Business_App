import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // Simulated API endpoint (using JSONPlaceholder style but with our data)
  static const String baseUrl = 'https://my-json-server.typicode.com/demo';

  // For demo purposes, we'll simulate API call
  Future<List<Product>> fetchProducts() async {
    try {
      // Simulating network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock product data
      final List<dynamic> mockData = [
        {
          'id': 1,
          'name': 'Premium Laptop',
          'dealerPrice': 75000,
          'retailPrice': 85000,
          'moq': 2,
          'barcode': '1234567890',
        },
        {
          'id': 2,
          'name': 'Wireless Mouse',
          'dealerPrice': 1200,
          'retailPrice': 1500,
          'moq': 5,
          'barcode': '1234567891',
        },
        {
          'id': 3,
          'name': 'Mechanical Keyboard',
          'dealerPrice': 3500,
          'retailPrice': 4500,
          'moq': 3,
          'barcode': '1234567892',
        },
        {
          'id': 4,
          'name': '4K Monitor',
          'dealerPrice': 25000,
          'retailPrice': 30000,
          'moq': 2,
          'barcode': '1234567893',
        },
        {
          'id': 5,
          'name': 'USB-C Hub',
          'dealerPrice': 1800,
          'retailPrice': 2200,
          'moq': 4,
          'barcode': '1234567894',
        },
      ];

      return mockData.map((json) => Product.fromJson(json)).toList();

    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}