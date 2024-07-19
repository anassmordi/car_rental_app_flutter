import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Method to decode the token and get the role
  String? getRoleFromToken(String token) {
    try {
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      return payload['scope']; // Assuming the role is stored in the 'scope' claim
    } catch (error) {
      print('Error decoding token: $error');
      return null;
    }
  }

  // Method to decode the token and get the user's name
  String? getUserNameFromToken(String token) {
    try {
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      return payload['user']; // Assuming the user's name is stored in the 'user' claim
    } catch (error) {
      print('Error decoding token: $error');
      return null;
    }
  }

  // Method to save tokens and role
  Future<void> saveToken(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);

    String? role = getRoleFromToken(accessToken);
    if (role != null) {
      await prefs.setString('userRole', role);
      print('Stored Role: $role'); // Print the stored role
    }

    String? userName = getUserNameFromToken(accessToken);
    if (userName != null) {
      await prefs.setString('userName', userName);
      print('Stored User Name: $userName'); // Print the stored user name
    }
  }

  // Method to get token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Method to get role
  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }

  // Method to get user name
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  // Method to remove token, role, and user name
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('userRole');
    await prefs.remove('userName');
  }
}
