import 'package:bghit_nsog/pages/results_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:geolocator/geolocator.dart';
import 'login_page.dart';
import 'filter_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'details_page.dart';
import 'car_recommendations_page.dart';
import 'notifications_page.dart';
import '../api_constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PanelController _panelController = PanelController();
  List<dynamic> _carsByLocation = [];
  List<dynamic> _carsByClick = [];
  bool _isLoading = true;
  String? _error;
  String _currentCity = 'Loading...'; // Add a field to store the current city
  final String openCageApiKey = "f653df93cf4e4621b5c293241892b493"; // Your OpenCage API key

  @override
  void initState() {
    super.initState();
    _fetchCars();
    _getCurrentLocation(); // Fetch current location and city name
  }

  Future<void> _fetchCars() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final url = Uri.parse('$BASE_URL/api/cars');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _carsByLocation = data['carsByLocation'] ?? [];
          _carsByClick = data['carsByClick'] ?? [];
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

  void toggleFilterPanel() {
    if (_panelController.isPanelClosed) {
      _panelController.open();
    } else {
      _panelController.close();
    }
  }

  Future<void> _applyTypeFilter(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final url = Uri.parse('$BASE_URL/api/cars/search');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final body = {'type': type};

    try {
      final response = await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final carsWithPromotions = data['carsWithPromotions'] ?? [];
        final otherCars = data['otherCars'] ?? [];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPage(
              carsWithPromotions: carsWithPromotions,
              otherCars: otherCars,
            ),
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
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

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _getAddressFromLatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    final url =
        'https://api.opencagedata.com/geocode/v1/json?q=$lat+$lng&key=$openCageApiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          setState(() {
            _currentCity = data['results'][0]['components']['city'] ?? 'Unknown city';
          });
        } else {
          setState(() {
            _currentCity = "No city available.";
          });
        }
      } else {
        setState(() {
          _currentCity = "Error fetching geocoding data.";
        });
      }
    } catch (e) {
      setState(() {
        _currentCity = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            _currentCity, // Update to display current city
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications_none, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NotificationsPage()),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search cars by brand',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: toggleFilterPanel,
                      ),
                      SizedBox(width: 17),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              buildChoiceChip('Sedan'),
                              SizedBox(width: 17),
                              buildChoiceChip('Hatchback'),
                              SizedBox(width: 17),
                              buildChoiceChip('Suv'),
                              SizedBox(width: 17),
                              buildChoiceChip('Van'),
                              SizedBox(width: 17),
                              buildChoiceChip('Economy'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Available cars near you',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(child: Text(_error!))
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _carsByLocation.map((car) {
                                  return buildCarCard(
                                    car['imageFileNames'][0],
                                    '${car['make']} ${car['model']}',
                                    car['type'],
                                    'MAD${car['price']}',
                                    car['id'].toString(),
                                  );
                                }).toList(),
                              ),
                            ),
                  SizedBox(height: 24),
                  Text(
                    'Car recommendations',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(child: Text(_error!))
                          : Column(
                              children: _carsByClick.map((car) {
                                return buildRecommendationCard(
                                  car['imageFileNames'][0],
                                  '${car['make']} ${car['model']}',
                                  car['type'],
                                  'MAD${car['price']}',
                                  car['id'].toString(),
                                );
                              }).toList(),
                            ),
                ],
              ),
            ),
          ),
          SlidingUpPanel(
            controller: _panelController,
            panelBuilder: (scrollController) => FilterSlider(
              scrollController: scrollController,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            minHeight: 0, // Ensure the panel starts hidden
            maxHeight: MediaQuery.of(context).size.height * 0.84,
            backdropEnabled: true,
            backdropTapClosesPanel: true,
          ),
        ],
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
              // Navigator.pushReplacementNamed(context, '/homePage');
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CarRecommendationsPage()),
              );
              break;
            case 2:
              // Navigator.pushNamed(context, '/rideHistory'); // Add this route if it exists
              break;
            case 3:
              Navigator.pushNamed(context, '/profile'); // Navigate to ProfilePage
              break;
          }
        },
      ),
    );
  }

  Widget buildChoiceChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: false,
      backgroundColor: Color(0xFFF8F8F8),
      selectedColor: Color(0xFFF8F8F8),
      onSelected: (selected) {
        _applyTypeFilter(label);
      },
    );
  }

  Widget buildCarCard(String imagePath, String title, String type, String price, String carId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              carId: carId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 13.0, bottom: 10, left: 5),
        child: Container(
          width: 165,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 0.5,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            children: [
              FutureBuilder<Uint8List>(
                future: _fetchImage(imagePath),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Icon(Icons.error);
                  } else {
                    return Image.memory(snapshot.data!, height: 95, fit: BoxFit.contain);
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      type,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text('$price/day', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRecommendationCard(String imagePath, String title, String type, String price, String carId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              carId: carId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 16.0),
            leading: FutureBuilder<Uint8List>(
              future: _fetchImage(imagePath),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Icon(Icons.error);
                } else {
                  return Image.memory(snapshot.data!, width: 100, height: 60, fit: BoxFit.contain);
                }
              },
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: TextStyle(fontSize: 16)),
                SizedBox(height: 3),
                Text('$price/day', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
