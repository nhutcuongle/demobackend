import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../models/product.dart';

class ProductService {
  static final String? baseUrl = dotenv.env['BASE_URL'];


  static Future<bool> createProduct({
    required String name,
    required double price,
    String? description,
    File? imageFile,
  }) async {
    final uri = Uri.parse('$baseUrl/api/products');

    var request = http.MultipartRequest('POST', uri);

    request.fields['name'] = name;
    request.fields['price'] = price.toString();

    if (description != null) {
      request.fields['description'] = description;
    }

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // 👈 phải trùng backend
          imageFile.path,
        ),
      );
    }

    final response = await request.send();

    return response.statusCode == 201;
  }
  static Future<List<Product>> getAllProducts() async {
    final uri = Uri.parse('$baseUrl/api/products');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
  static Future<bool> updateProduct({
    required String id,
    required String name,
    required double price,
    String? description,
    File? imageFile,
  }) async {
    final uri = Uri.parse('$baseUrl/api/products/$id');

    var request = http.MultipartRequest('PUT', uri);

    request.fields['name'] = name;
    request.fields['price'] = price.toString();

    if (description != null) {
      request.fields['description'] = description;
    }

    // Nếu có chọn ảnh mới thì mới upload
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );
    }

    final response = await request.send();
    return response.statusCode == 200;
  }

  static Future<bool> deleteProduct(String id) async {
    final uri = Uri.parse('$baseUrl/api/products/$id');

    final response = await http.delete(uri);

    return response.statusCode == 200;
  }

}
