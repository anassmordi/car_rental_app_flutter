import 'package:flutter/material.dart';
import 'car_form_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:bghit_nsog/api_constants.dart';

class DetailsPageAgency extends StatefulWidget {
  final String carId;

  DetailsPageAgency({required this.carId});

  @override
  _DetailsPageAgencyState createState() => _DetailsPageAgencyState();
}

class _DetailsPageAgencyState extends State<DetailsPageAgency> {
  Map<String, dynamic>? _carDetails;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCarDetails();
  }

  Future<void> _fetchCarDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final url = Uri.parse('$BASE_URL/api/cars/${widget.carId}');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _carDetails = data['car'];
          _isLoading = false;
        });
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          _error = data['message'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<Uint8List> _fetchImage(String imageName) async {
    try {
      final correctedImageName = imageName.replaceFirst(RegExp(r'^images\\cars\\'), '');
      final filePath = p.join('C:\\Users\\anass\\Documents\\', correctedImageName);
      final file = File(filePath);
      if (await file.exists()) {
        return file.readAsBytes();
      } else {
        throw Exception('Image not found');
      }
    } catch (e) {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xFFF8F8F8),
        elevation: 0,
        title: Text('Details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: _carDetails != null && _carDetails!['imageFileNames'].isNotEmpty 
                            ? FutureBuilder<Uint8List>(
                                future: _fetchImage(_carDetails!['imageFileNames'][0]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Icon(Icons.error);
                                  } else {
                                    return Image.memory(snapshot.data!, height: 200, fit: BoxFit.contain);
                                  }
                                },
                              )
                            : Icon(Icons.car_rental, size: 200),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_carDetails!['make']} ${_carDetails!['model']}',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _carDetails!['type'],
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'MAD',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: _carDetails!['price'].toString(),
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: '/day',
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                  if (_carDetails!['promotion'])
                                    TextSpan(
                                      text: ' (${_carDetails!['percentage']}% Off)',
                                      style: TextStyle(fontSize: 16, color: Colors.red),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            buildFeatureChip(Icons.local_gas_station, _carDetails!['fuelType']),
                            buildFeatureChip(Icons.settings, _carDetails!['transmissionType']),
                            buildFeatureChip(Icons.airline_seat_recline_normal, _carDetails!['seats'].toString()),
                            buildFeatureChip(Icons.ac_unit, 'AC'),
                            buildFeatureChip(Icons.speed, '120/km'),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Overview',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _carDetails!['description'] ?? 'No description available.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 140,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CarFormPage(carDetails: _carDetails),
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF4550AA), // button background color
                                  foregroundColor: Colors.white, // text color
                                  padding: EdgeInsets.symmetric(vertical: 20.0), // Adjust padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // less rounded corners
                                  ),
                                  minimumSize: Size(0, 50), // height of the button
                                ),
                              ),
                            ),
                            SizedBox(width: 20), // Space between the buttons
                            SizedBox(
                              width: 140,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle delete action
                                },
                                child: Center(
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red, // button background color
                                  foregroundColor: Colors.white, // text color
                                  padding: EdgeInsets.symmetric(vertical: 20.0), // Adjust padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // less rounded corners
                                  ),
                                  minimumSize: Size(0, 50), // height of the button
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Cars',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/homePageAgency');
              break;
            case 1:
              // Navigator.pushNamed(context, '/cars'); // Add this route if it exists
              break;
            case 2:
              // Navigator.pushNamed(context, '/bookings'); // Add this route if it exists
              break;
            case 3:
              Navigator.pushNamed(context, '/profileAgency'); // Navigate to ProfilePageAgency
              break;
          }
        },
      ),
    );
  }

  Widget buildFeatureChip(IconData iconData, String label) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10), // Increased margin
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(iconData, color: Colors.black),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
