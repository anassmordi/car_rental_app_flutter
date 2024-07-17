import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:bghit_nsog/api_constants.dart'; // Import the API constants

class BecomeAgencyPage extends StatefulWidget {
  @override
  _BecomeAgencyPageState createState() => _BecomeAgencyPageState();
}

class _BecomeAgencyPageState extends State<BecomeAgencyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _fleetSizeController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  Future<void> _becomeAgency() async {
    if (_formKey.currentState!.validate() && _latitude != null && _longitude != null) {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      final url = Uri.parse('$BASE_URL/$BECOME_AGENCY_URL'); // Use the BASE_URL and BECOME_AGENCY_URL
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final body = jsonEncode({
        'companyName': _companyNameController.text,
        'jobTitle': _jobTitleController.text,
        'fleetSize': _fleetSizeController.text,
        'contactNumber': _contactNumberController.text,
        'city': _cityController.text,
        'address': _addressController.text,
        'latitude': _latitude,
        'longitude': _longitude,
      });

      final response = await http.patch(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have become an agency successfully')));
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'])));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location not available')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Become an Agency')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _companyNameController,
                decoration: InputDecoration(labelText: 'Company Name'),
                validator: (value) => value!.isEmpty ? 'Please enter the company name' : null,
              ),
              TextFormField(
                controller: _jobTitleController,
                decoration: InputDecoration(labelText: 'Job Title'),
                validator: (value) => value!.isEmpty ? 'Please enter the job title' : null,
              ),
              TextFormField(
                controller: _fleetSizeController,
                decoration: InputDecoration(labelText: 'Fleet Size'),
                validator: (value) => value!.isEmpty ? 'Please enter the fleet size' : null,
              ),
              TextFormField(
                controller: _contactNumberController,
                decoration: InputDecoration(labelText: 'Contact Number'),
                validator: (value) => value!.isEmpty ? 'Please enter the contact number' : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) => value!.isEmpty ? 'Please enter the city' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Please enter the address' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _becomeAgency,
                child: Text('Become an Agency'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
