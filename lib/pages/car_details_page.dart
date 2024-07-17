import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:bghit_nsog/api_constants.dart';

class CarDetailsPage extends StatefulWidget {
  final String carId;

  CarDetailsPage({required this.carId});

  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
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
      appBar: AppBar(title: Text('Car Details')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${_carDetails!['make']} ${_carDetails!['model']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text('Type: ${_carDetails!['type']}'),
                        Text('Price: ${_carDetails!['price']}'),
                        Text('Fuel Type: ${_carDetails!['fuelType']}'),
                        Text('Transmission: ${_carDetails!['transmissionType']}'),
                        Text('Seats: ${_carDetails!['seats']}'),
                        Text('Year: ${_carDetails!['year']}'),
                        Text('Description: ${_carDetails!['description']}'),
                        _carDetails!['promotion']
                            ? Text('${_carDetails!['percentage']}% Off', style: TextStyle(color: Colors.red))
                            : Container(),
                        SizedBox(height: 10),
                        ...(_carDetails!['imageFileNames'] as List).map((imageName) {
                          return FutureBuilder<Uint8List>(
                            future: _fetchImage(imageName),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Icon(Icons.error);
                              } else {
                                return SizedBox(
                                  width: double.infinity,
                                  child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                                );
                              }
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
    );
  }
}
