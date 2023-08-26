import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:payetonkawa/models/jwtResponse.dart';
import 'package:payetonkawa/models/products.dart';

import '../models/retailers.dart';

class revendeurService {
  static const String baseUrl =
      'https://retailer.msprpayetonkawa.xyz/';

  static Future<List<Products>> getProducts() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt');
    final response = await http.get(Uri.parse("${baseUrl}api/product"), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return parseProductsPosts(response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load data');
    }
  }

  static Future<Products> getProductsbyUid(String uid) async {   
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt');
    final response =
        await http.get(Uri.parse("${baseUrl}api/product/$uid"), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Products.fromJson(jsonDecode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load data');
    }
  }

  static Future<JwtResponse> login(String email) async {
    var body = jsonEncode({"username": email});

    final response = await http.post(
      Uri.parse("${baseUrl}api/auth/signin"),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return JwtResponse.fromJson(jsonDecode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load data');
    }
  }

  static List<Products> parseProductsPosts(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Products>((json) => Products.fromJson(json)).toList();
  }

  static List<Retailers> parseRetailersPosts(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Retailers>((json) => Retailers.fromJson(json)).toList();
  }

  static Future<List<Retailers>> getRetailers() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt');
    final response = await http.get(Uri.parse("${baseUrl}api/retailer"), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return parseRetailersPosts(response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load data');
    }
  }

  static Future<Retailers> getRetailerbyEmail(String email) async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt');
    final response =
        await http.get(Uri.parse("${baseUrl}api/retailer/$email"), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Retailers.fromJson(jsonDecode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load data');
    }
  }
}
