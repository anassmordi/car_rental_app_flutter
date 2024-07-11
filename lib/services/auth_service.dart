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

  // Method to remove token and role
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('userRole');
  }
}
