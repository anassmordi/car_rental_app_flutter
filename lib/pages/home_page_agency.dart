import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:geolocator/geolocator.dart';
import 'package:bghit_nsog/api_constants.dart';
import 'login_page.dart';
import 'filter_page_agency.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'details_page_agency.dart';
import 'results_page_agency.dart';

class HomePageAgency extends StatefulWidget {
  @override
  _HomePageAgencyState createState() => _HomePageAgencyState();
}

class _HomePageAgencyState extends State<HomePageAgency> {
  final PanelController _panelController = PanelController();
  List<dynamic> _cars = [];
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
          _cars = data['carsByAgency'] ?? [];
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

  void _applyTypeFilter(String type) {
    final filteredCars = _cars.where((car) => car['type'] == type).toList();
    final carsWithPromotions = filteredCars.where((car) => car['promotion']).toList();
    final otherCars = filteredCars.where((car) => !car['promotion']).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPageAgency(
          carsWithPromotions: carsWithPromotions,
          otherCars: otherCars,
          allCars: _cars, // Pass the original list
        ),
      ),
    );
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
                          // Navigate to NotificationsPage
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
                              ChoiceChip(
                                label: Text('Sedan'),
                                selected: false,
                                backgroundColor: Color(0xFFF8F8F8),
                                selectedColor: Color(0xFFF8F8F8),
                                disabledColor: Color(0xFFF8F8F8),
                                onSelected: (bool selected) {
                                  _applyTypeFilter('Sedan');
                                },
                              ),
                              SizedBox(width: 17),
                              ChoiceChip(
                                label: Text('Hatchback'),
                                selected: false,
                                backgroundColor: Color(0xFFF8F8F8),
                                selectedColor: Color(0xFFF8F8F8),
                                disabledColor: Color(0xFFF8F8F8),
                                onSelected: (bool selected) {
                                  _applyTypeFilter('Hatchback');
                                },
                              ),
                              SizedBox(width: 17),
                              ChoiceChip(
                                label: Text('SUV'),
                                selected: false,
                                backgroundColor: Color(0xFFF8F8F8),
                                selectedColor: Color(0xFFF8F8F8),
                                disabledColor: Color(0xFFF8F8F8),
                                onSelected: (bool selected) {
                                  _applyTypeFilter('SUV');
                                },
                              ),
                              SizedBox(width: 17),
                              ChoiceChip(
                                label: Text('Van'),
                                selected: false,
                                backgroundColor: Color(0xFFF8F8F8),
                                selectedColor: Color(0xFFF8F8F8),
                                disabledColor: Color(0xFFF8F8F8),
                                onSelected: (bool selected) {
                                  _applyTypeFilter('Van');
                                },
                              ),
                              SizedBox(width: 17),
                              ChoiceChip(
                                label: Text('Economy'),
                                selected: false,
                                backgroundColor: Color(0xFFF8F8F8),
                                selectedColor: Color(0xFFF8F8F8),
                                disabledColor: Color(0xFFF8F8F8),
                                onSelected: (bool selected) {
                                  _applyTypeFilter('Economy');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Added Cars',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(child: Text(_error!))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _cars.length,
                              itemBuilder: (context, index) {
                                final car = _cars[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailsPageAgency(carId: car['id'].toString()),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 16),
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
                                      contentPadding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 16.0),
                                      leading: FutureBuilder<Uint8List>(
                                        future: _fetchImage(car['imageFileNames'][0]),
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
                                        '${car['make']} ${car['model']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(car['type'], style: TextStyle(fontSize: 16)),
                                          SizedBox(height: 3),
                                          Text('MAD${car['price']}/day', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      trailing: car['promotion']
                                          ? Text('${car['percentage']}% Off', style: TextStyle(color: Colors.red))
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                ],
              ),
            ),
          ),
          SlidingUpPanel(
            controller: _panelController,
            panelBuilder: (ScrollController scrollController) => FilterSliderAgency(
              scrollController: scrollController,
              cars: _cars, // Pass the cars list here
              onFilterApplied: (filteredCars) { // Handle the filtered results
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultsPageAgency(
                      carsWithPromotions: filteredCars.where((car) => car['promotion']).toList(),
                      otherCars: filteredCars.where((car) => !car['promotion']).toList(),
                      allCars: _cars, // Pass the original list
                    ),
                  ),
                );
              },
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height * 0.84,
            backdropEnabled: true,
            backdropTapClosesPanel: true,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/carForm');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
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
              Navigator.pushNamed(context, '/agencyCars');
              break;
            case 2:
              // Navigator.pushNamed(context, '/bookings'); // Add this route if it exists
              break;
            case 3:
              Navigator.pushNamed(context, '/profileAgency'); // Navigate to ProfilePage
              break;
          }
        },
      ),
    );
  }
}
