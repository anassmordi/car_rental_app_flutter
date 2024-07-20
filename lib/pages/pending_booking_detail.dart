import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path/path.dart' as p;
import '../api_constants.dart';
import 'home_page.dart';  // Import the home page

class PendingBookingDetailPage extends StatefulWidget {
  final Map<String, dynamic> booking;

  PendingBookingDetailPage({required this.booking});

  @override
  _PendingBookingDetailPageState createState() => _PendingBookingDetailPageState();
}

class _PendingBookingDetailPageState extends State<PendingBookingDetailPage> {
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.booking['startDate'])));
    _endDateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.booking['endDate'])));
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(controller.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _updateBooking() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final url = Uri.parse('$BASE_URL/api/bookings');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final body = jsonEncode({
      'bookingId': widget.booking['id'],
      'startDate': _startDateController.text,
      'endDate': _endDateController.text,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
        );
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred. Please try again.')));
    }
  }

  Future<void> _cancelBooking() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final url = Uri.parse('$BASE_URL/api/bookings/${widget.booking['id']}');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
        );
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred. Please try again.')));
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
    final car = widget.booking['car'] ?? {};
    final user = widget.booking['user'] ?? {};
    final status = widget.booking['status'] ?? 'Unknown status';
    final make = car['make'] ?? 'Unknown make';
    final model = car['model'] ?? 'Unknown model';
    final fuelType = car['fuelType'] ?? 'Unknown fuel type';
    final transmissionType = car['transmissionType'] ?? 'Unknown transmission type';
    final type = car['type'] ?? 'Unknown type';
    final matriculate = car['matriculate'] ?? 'Unknown matriculate';
    final seats = car['seats'] ?? 'Unknown seats';
    final year = car['year'] ?? 'Unknown year';
    final promotion = car['promotion'] ?? false;
    final percentage = car['percentage'] ?? 0.0;
    final price = car['price'] != null ? 'MAD${car['price']}' : 'Unknown price';
    final description = car['description'] ?? 'No description available';
    final imageFileName = car['imageFileNames'] != null ? car['imageFileNames'][0] : '';

    final formattedStartDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.booking['startDate']));
    final formattedEndDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.booking['endDate']));

    bool canCancel = status == 'PENDING';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('$make $model Details',  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<Uint8List>(
                future: _fetchImage(imageFileName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return SizedBox(
                      height: 200,
                      child: Center(child: Icon(Icons.error)),
                    );
                  } else {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(
                        snapshot.data!,
                        height: 280,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 20),

              Text(
                'Make: $make',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Model: $model',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Fuel Type: $fuelType',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Transmission: $transmissionType',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Type: $type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Matriculate: $matriculate',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Seats: $seats',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Year: $year',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Promotion: ${promotion ? "Yes" : "No"}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Discount: $percentage%',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Description:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                description,
                style: TextStyle(fontSize: 16),
              ),
              // SizedBox(height: 20),
              // Text(
              //   'User: $user',
              //   style: TextStyle(fontSize: 18, color: Colors.grey),
              // ),
              SizedBox(height: 20),
              TextField(
                controller: _startDateController,
                readOnly: true,
                onTap: () => _selectDate(context, _startDateController),
                decoration: InputDecoration(
                  labelText: 'Pickup Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _endDateController,
                readOnly: true,
                onTap: () => _selectDate(context, _endDateController),
                decoration: InputDecoration(
                  labelText: 'Return Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateBooking,
                child: Text('Update Booking'),
              ),
              SizedBox(height: 20),
              if (canCancel)
                ElevatedButton(
                  onPressed: _cancelBooking,
                  child: Text('Cancel Booking',style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              
            ],
          ),
        ),
      ),
    );
  }
}
