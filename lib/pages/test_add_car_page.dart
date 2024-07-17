import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:bghit_nsog/api_constants.dart'; // Import the API constants

class TestAddCarPage extends StatefulWidget {
  @override
  _TestAddCarPageState createState() => _TestAddCarPageState();
}

class _TestAddCarPageState extends State<TestAddCarPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();
  final TextEditingController _transmissionTypeController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _matriculateController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<PlatformFile> _pickedFiles = [];

  Future<void> _addCar() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      // Save images locally and get their paths
      List<String> imageFilePaths = await _saveImagesLocally();

      final url = Uri.parse('$BASE_URL/$ADD_CAR_URL'); // Use the BASE_URL and ADD_CAR_URL
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      try {
        final body = jsonEncode({
          'make': _makeController.text,
          'model': _modelController.text,
          'fuelType': _fuelTypeController.text,
          'transmissionType': _transmissionTypeController.text,
          'type': _typeController.text,
          'matriculate': _matriculateController.text,
          'seats': int.parse(_seatsController.text),
          'year': int.parse(_yearController.text),
          'description': _descriptionController.text,
          'price': double.parse(_priceController.text),
          'imageFileNames': imageFilePaths, // Use image file paths
        });

        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Car added successfully')));
        } else {
          final responseData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'])));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid input. Please check your entries.')));
      }
    }
  }

  Future<List<String>> _saveImagesLocally() async {
    List<String> imageFilePaths = [];

    for (var file in _pickedFiles) {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(appDir.path, 'images', 'cars'));
      if (!imagesDir.existsSync()) {
        imagesDir.createSync(recursive: true);
      }
      final filePath = p.join(imagesDir.path, p.basename(file.path!));
      final savedFile = await File(file.path!).copy(filePath);
      // Create a relative path
      final relativePath = p.join('images', 'cars', p.basename(file.path!)).replaceAll('\\', '/');
      imageFilePaths.add(relativePath);
    }

    return imageFilePaths;
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        _pickedFiles = result.files;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Add Car API')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _makeController,
                decoration: InputDecoration(labelText: 'Make'),
                validator: (value) => value!.isEmpty ? 'Please enter the make' : null,
              ),
              TextFormField(
                controller: _modelController,
                decoration: InputDecoration(labelText: 'Model'),
                validator: (value) => value!.isEmpty ? 'Please enter the model' : null,
              ),
              TextFormField(
                controller: _fuelTypeController,
                decoration: InputDecoration(labelText: 'Fuel Type'),
                validator: (value) => value!.isEmpty ? 'Please enter the fuel type' : null,
              ),
              TextFormField(
                controller: _transmissionTypeController,
                decoration: InputDecoration(labelText: 'Transmission Type'),
                validator: (value) => value!.isEmpty ? 'Please enter the transmission type' : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(labelText: 'Type'),
                validator: (value) => value!.isEmpty ? 'Please enter the type' : null,
              ),
              TextFormField(
                controller: _matriculateController,
                decoration: InputDecoration(labelText: 'Matriculate'),
                validator: (value) => value!.isEmpty ? 'Please enter the matriculate' : null,
              ),
              TextFormField(
                controller: _seatsController,
                decoration: InputDecoration(labelText: 'Seats'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter the number of seats' : null,
              ),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter the year' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Please enter the description' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter the price' : null,
              ),
              ElevatedButton(
                onPressed: _pickFiles,
                child: Text('Pick Images'),
              ),
              SizedBox(height: 10),
              Text(_pickedFiles.isNotEmpty ? 'Picked Files: ${_pickedFiles.map((e) => e.name).join(', ')}' : 'No files picked'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addCar,
                child: Text('Add Car'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/becomeAgency');
                },
                child: Text('Become an Agency'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
