import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:smart_cart/classes/user.dart';
import 'package:smart_cart/consts.dart';

class UserServices {
  Future<User?> loginUser(String email, String password) async {
    final _url = Uri.parse('$url/api/login');
    final Map<String, String> body = {
      'email': email,
      'password': password,
    };
    try {
      final response = await http.post(
        _url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Login successful: $data');
        return User.fromMap(data);
      } else {
        // Decode the response body to extract the error message
        final responseBody = json.decode(response.body);
        final errorMessage = responseBody['error'] ??
            responseBody['message'] ??
            'Failed to login';

        print('Failed to login. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        // Display the error message as a toast
        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
        );
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      Fluttertoast.showToast(
        msg: 'An error occurred: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
      );
      return null;
    }
  }

  Future<void> registerUser(User newUser, String password) async {
    final _url = Uri.parse('$url/api/register');
    final Map<String, String> body = {
      'name': newUser.name,
      'email': newUser.email,
      'password': password,
      'phoneNumber': newUser.phoneNumber ?? '', // Handle null values gracefully
    };

    try {
      final response = await http.post(
        _url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        print('Registration successful: $data');

        Fluttertoast.showToast(
          msg: 'Verification email sent!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        // Decode the response body to extract the specific error message
        final responseBody = json.decode(response.body);
        final errorMessage = responseBody['error'] ??
            responseBody['message'] ??
            'Failed to register';

        print('Failed to register. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        // Show a toast with the specific error message
        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Error occurred: $e');

      Fluttertoast.showToast(
        msg: 'An error occurred: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final _url = Uri.parse('$url/api/reset-password');
    final Map<String, String> body = {
      'email': email,
    };

    try {
      final response = await http.post(
        _url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Fluttertoast.showToast(
          msg: data['message'] ?? 'Sent Successfully',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
        );
      } else {
        // Decode the response body to extract the error message
        final responseBody = json.decode(response.body);
        final errorMessage = responseBody['error'] ??
            responseBody['message'] ??
            'Something went wrong';

        print('Failed to send link. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        // Display the error message as a toast
        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
        );
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      Fluttertoast.showToast(
        msg: 'An error occurred: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
      );
      return null;
    }
  }
}
