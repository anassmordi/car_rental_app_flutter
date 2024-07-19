import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'login_page.dart'; // Ensure to import LoginPage
import '../api_constants.dart'; // Ensure this file contains the BASE_URL and GET_CAR_URL

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String companyName = '';
  String jobTitle = '';
  String fleetSize = '';
  String contactNumber = '';
  String city = '';
  String address = '';
  bool _isLoading = false; // State to handle loading

  Future<void> becomeAgency(BuildContext context) async {
    setState(() {
      _isLoading = true; // Show loading screen
    });

    try {
      // Get current location
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      double latitude = position.latitude;
      double longitude = position.longitude;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      if (accessToken == null) {
        throw Exception('Access token not found');
      }

      final response = await http.patch(
        Uri.parse('$BASE_URL/api/auth/becomeAgency'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'companyName': companyName,
          'jobTitle': jobTitle,
          'fleetSize': fleetSize,
          'contactNumber': contactNumber,
          'city': city,
          'address': address,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context);
      } else {
        final error = jsonDecode(response.body)['message'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: ${e.toString()}')));
    } finally {
      setState(() {
        _isLoading = false; // Hide loading screen
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 100, color: Colors.green),
              SizedBox(height: 20),
              Text('Information submitted successfully', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );

    // Automatically close the dialog after 3 seconds and navigate to the login page
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the dialog
      logout(context); // Log out the user
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Registration', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24)),
        backgroundColor: Color(0xFFF8F8F8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20), // Add this to lower the input fields
                    buildTextField('Your Name', 'Enter your name', (value) => userName = value),
                    buildTextField('Company Name', 'Enter your Company Name', (value) => companyName = value),
                    buildTextField('Job Title', 'Owner / Founder', (value) => jobTitle = value),
                    buildTextField('Fleet Size', '5-10 cars', (value) => fleetSize = value),
                    buildPhoneNumberField(),
                    buildTextField('City', 'Select City', (value) => city = value),
                    buildTextField('Address', 'Enter your address', (value) => address = value),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          becomeAgency(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4550AA), // Button background color
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Send', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildPhoneNumberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: IntlPhoneField(
        decoration: InputDecoration(
          labelText: 'Contact No.',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey), // Grey border color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey), // Grey border color for enabled state
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey), // Grey border color for focused state
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        initialCountryCode: 'MA',
        onChanged: (phone) {
          contactNumber = phone.completeNumber; // Save the complete phone number
        },
      ),
    );
  }

  Widget buildTextField(String label, String hint, Function(String) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey), // Grey border color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey), // Grey border color for enabled state
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey), // Grey border color for focused state
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        onSaved: (value) => onSaved(value!),
      ),
    );
  }
}
