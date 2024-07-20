import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'pending_booking_detail.dart';
import '../api_constants.dart';

class PendingBookingsPage extends StatefulWidget {
  @override
  _PendingBookingsPageState createState() => _PendingBookingsPageState();
}

class _PendingBookingsPageState extends State<PendingBookingsPage> {
  List<dynamic> _bookings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final url = Uri.parse('$BASE_URL/api/bookings');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.get(url, headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Print the response body

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _bookings = data['bookings'] ?? [];
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
        title: Text('Bookings', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24)),
        backgroundColor: Color(0xFFF8F8F8),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    final booking = _bookings[index];
                    final car = booking['car'] ?? {};
                    final make = car['make'] ?? 'Unknown make';
                    final model = car['model'] ?? 'Unknown model';
                    final startDate = booking['startDate'] ?? 'Unknown start date';
                    final endDate = booking['endDate'] ?? 'Unknown end date';
                    final status = booking['status'] ?? 'Unknown status';
                    final price = car['price'] != null ? 'MAD${car['price']}' : 'Unknown price';
                    final imageFileName = car['imageFileNames'] != null ? car['imageFileNames'][0] : '';

                    final formattedStartDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(startDate));
                    final formattedEndDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(endDate));

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PendingBookingDetailPage(
                              booking: booking,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: status == 'CANCELLED' ? Colors.grey[300] : Colors.white,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              FutureBuilder<Uint8List>(
                                future: _fetchImage(imageFileName),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  } else if (snapshot.hasError) {
                                    return SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Center(child: Icon(Icons.error)),
                                    );
                                  } else {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.memory(
                                        snapshot.data!,
                                        width: 110,
                                        height: 70,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }
                                },
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$make $model',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Pickup: $formattedStartDate',
                                      style: TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                    Text(
                                      'Return: $formattedEndDate',
                                      style: TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                    Text(
                                      'Status: $status',
                                      style: TextStyle(fontSize: 14, color: status == 'CANCELLED' ? Colors.red : Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                status == 'CANCELLED' ? 'Canceled' : price,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
