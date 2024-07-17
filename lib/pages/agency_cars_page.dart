import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:bghit_nsog/api_constants.dart';
import 'car_details_page.dart';

class AgencyCarsPage extends StatefulWidget {
  @override
  _AgencyCarsPageState createState() => _AgencyCarsPageState();
}

class _AgencyCarsPageState extends State<AgencyCarsPage> {
  List<dynamic> _cars = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCars();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Cars')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  itemCount: _cars.length,
                  itemBuilder: (context, index) {
                    final car = _cars[index];
                    return Card(
                      child: ListTile(
                        leading: FutureBuilder<Uint8List>(
                          future: _fetchImage(car['imageFileNames'][0]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Icon(Icons.error);
                            } else {
                              return SizedBox(
                                width: 100,
                                height: 60,
                                child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                              );
                            }
                          },
                        ),
                        title: Text('${car['make']} ${car['model']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Type: ${car['type']}, Price: ${car['price']}'),
                            Text('Image Name: ${car['imageFileNames'][0]}'), // Debug print in UI
                          ],
                        ),
                        trailing: car['promotion']
                            ? Text('${car['percentage']}% Off', style: TextStyle(color: Colors.red))
                            : null,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CarDetailsPage(carId: car['id'].toString())),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
