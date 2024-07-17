import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_constants.dart'; // Import the constants

class DetailsPage extends StatefulWidget {
  final String carId;

  DetailsPage({required this.carId});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<Map<String, dynamic>> carDetails;

  @override
  void initState() {
    super.initState();
    carDetails = fetchCarDetails(widget.carId);
  }

  Future<Map<String, dynamic>> fetchCarDetails(String carId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    final response = await http.get(
      Uri.parse('$BASE_URL/$GET_CAR_URL/$carId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['car'];
    } else {
      throw Exception('Failed to load car details');
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: carDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load car details'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          } else {
            final car = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: FutureBuilder<Uint8List>(
                      future: _fetchImage(car['imageFileNames'][0]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Icon(Icons.error);
                        } else {
                          return Image.memory(snapshot.data!, height: 200, fit: BoxFit.contain);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${car['make']} ${car['model']}',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            car['price'].toString(), // Use price directly
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
                                text: 'MAD ',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              TextSpan(
                                text: car['price'].toString(),
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              TextSpan(
                                text: '/day',
                                style: TextStyle(fontSize: 16, color: Colors.black),
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
                        buildFeatureChip(Icons.local_gas_station, car['fuelType']),
                        buildFeatureChip(Icons.settings, car['transmissionType']),
                        buildFeatureChip(Icons.airline_seat_recline_normal, car['seats'].toString()),
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
                    car['description'],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   // MaterialPageRoute(
                          //   //   // builder: (context) => BookingPage(
                          //   //   //   carId: car['id'],
                          //   //   //   title: '${car['make']} ${car['model']}',
                          //   //   //   price: car['price'].toString(),
                          //   //   // ),
                          //   // ),
                          // );
                        },
                        child: Center(
                          child: Text(
                            'Book Now',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4550AA),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(0, 50),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
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
              Navigator.pushReplacementNamed(context, '/homePage');
              break;
            case 1:
              // Navigator.pushNamed(context, '/cars'); // Add this route if it exists
              break;
            case 2:
              // Navigator.pushNamed(context, '/bookings'); // Add this route if it exists
              break;
            case 3:
              Navigator.pushNamed(context, '/profile'); // Navigate to ProfilePage
              break;
          }
        },
      ),
    );
  }

  Widget buildFeatureChip(IconData iconData, String label) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
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
