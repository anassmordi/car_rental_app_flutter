import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:bghit_nsog/api_constants.dart';
import 'package:file_picker/file_picker.dart';

class CarFormPage extends StatefulWidget {
  final Map<String, dynamic>? carDetails;

  CarFormPage({this.carDetails});

  @override
  _CarFormPageState createState() => _CarFormPageState();
}

class _CarFormPageState extends State<CarFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _matriculateController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController(); // Added controller for percentage
  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedFuelType;
  String? _selectedTransmissionType;
  String? _selectedSeats;
  String? _selectedType;
  String? _selectedStatus;
  bool _promotion = false; // Added field for promotion
  List<PlatformFile> _pickedFiles = [];

  final List<String> carBrands = [
    'BMW', 'Renault', 'Dacia', 'Mercedes', 'Volvo', 'Toyota', 'Honda', 'Ford', 'Chevrolet', 'Nissan',
    'Hyundai', 'Kia', 'Volkswagen', 'Audi', 'Mazda', 'Citroen'
  ];

  final Map<String, List<String>> carModels = {
    'BMW': ['1 Series', '3 Series', '5 Series', '7 Series', 'X1', 'X3', 'X5'],
    'Renault': ['Clio', 'Megane', 'Captur', 'Kadjar', 'Scenic'],
    'Dacia': ['Duster', 'Logan', 'Sandero'],
    'Mercedes': ['A-Class', 'C-Class', 'E-Class', 'S-Class', 'GLA', 'GLC', 'GLE'],
    'Volvo': ['XC40', 'XC60', 'XC90', 'S60', 'S90'],
    'Toyota': ['Camry', 'Corolla', 'Highlander', 'RAV4', 'Yaris'],
    'Honda': ['Accord', 'Civic', 'CR-V', 'Fit', 'HR-V'],
    'Ford': ['Escape', 'Explorer', 'F-150', 'Focus', 'Mustang'],
    'Chevrolet': ['Blazer', 'Camaro', 'Equinox', 'Malibu', 'Tahoe'],
    'Nissan': ['Altima', 'Maxima', 'Rogue', 'Sentra', 'Versa'],
    'Hyundai': ['Elantra', 'Kona', 'Palisade', 'Santa Fe', 'Sonata'],
    'Kia': ['Forte', 'Optima', 'Sorento', 'Soul', 'Sportage'],
    'Volkswagen': ['Atlas', 'Golf', 'Jetta', 'Passat', 'Tiguan'],
    'Audi': ['A3', 'A4', 'A6', 'Q5', 'Q7'],
    'Mazda': ['CX-3', 'CX-5', 'CX-9', 'Mazda3', 'Mazda6'],
    'Citroen': ['C3', 'C4', 'C5', 'Berlingo', 'DS3']
  };

  final List<String> carTypes = ['Suv', 'Hatchback', 'Sedan', 'Coupe', 'Convertible', 'Van', 'Wagon', 'Truck'];

  @override
  void initState() {
    super.initState();
    if (widget.carDetails != null) {
      _initializeFormFields();
    }
  }

  void _initializeFormFields() {
    _selectedBrand = widget.carDetails!['make'];
    _selectedModel = widget.carDetails!['model'];
    _matriculateController.text = widget.carDetails!['matriculate'];
    _yearController.text = widget.carDetails!['year'].toString();
    _descriptionController.text = widget.carDetails!['description'];
    _priceController.text = widget.carDetails!['price'].toString();
    _selectedFuelType = widget.carDetails!['fuelType'];
    _selectedTransmissionType = widget.carDetails!['transmissionType'];
    _selectedSeats = widget.carDetails!['seats'].toString();
    _selectedType = widget.carDetails!['type'];
    _selectedStatus = widget.carDetails!['status']?.toUpperCase();
    _promotion = widget.carDetails!['promotion'] ?? false; // Initialize promotion field
    _percentageController.text = widget.carDetails!['percentage']?.toString() ?? '0.0'; // Initialize percentage field
  }

  Future<void> _saveCar() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      // Save images locally and get their paths
      List<String> imageFilePaths = await _saveImagesLocally();

      final url = widget.carDetails == null
          ? Uri.parse('$BASE_URL/$ADD_CAR_URL') // Use the BASE_URL and ADD_CAR_URL
          : Uri.parse('$BASE_URL/api/cars/${widget.carDetails!['id']}'); // Edit URL
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      try {
        final body = jsonEncode({
          'make': _selectedBrand,
          'model': _selectedModel,
          'matriculate': _matriculateController.text,
          'year': int.parse(_yearController.text),
          'type': _selectedType,
          'fuelType': _selectedFuelType,
          'transmissionType': _selectedTransmissionType,
          'seats': int.parse(_selectedSeats!),
          'description': _descriptionController.text,
          'price': double.parse(_priceController.text),
          'imageFileNames': imageFilePaths,
          'status': _selectedStatus, // Add this line
          'promotion': _promotion, // Added promotion field
          'percentage': double.parse(_percentageController.text), // Added percentage field
        });

        final response = widget.carDetails == null
            ? await http.post(url, headers: headers, body: body)
            : await http.put(url, headers: headers, body: body);

        if (response.statusCode == 201 || response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(widget.carDetails == null ? 'Car added successfully' : 'Car updated successfully')));
          Navigator.pushReplacementNamed(context, '/homePageAgency'); // Navigate to homePageAgency on success
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

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.carDetails == null ? 'Add Car' : 'Edit Car'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickFiles,
                child: Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(
                    child: _pickedFiles.isEmpty
                        ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey[700])
                        : Image.file(File(_pickedFiles.first.path!)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedBrand,
                decoration: InputDecoration(
                  labelText: 'Brand',
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
                items: carBrands.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBrand = value;
                    _selectedModel = null; // Reset the selected model
                  });
                },
                validator: (value) => value == null ? 'Please select a brand' : null,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedModel,
                decoration: InputDecoration(
                  labelText: 'Model',
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
                items: _selectedBrand != null
                    ? carModels[_selectedBrand!]!.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()
                    : [],
                onChanged: (value) {
                  setState(() {
                    _selectedModel = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a model' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _matriculateController,
                decoration: InputDecoration(
                  labelText: 'Matriculate',
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter the matriculate' : null,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Type',
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
                items: carTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                validator: (value) => value == null ? 'Please select the type' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Year',
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter the year' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price / Day',
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter the price' : null,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedFuelType,
                decoration: InputDecoration(
                  labelText: 'Fuel Type',
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
                items: ['Gas', 'Diesel'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFuelType = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a fuel type' : null,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedTransmissionType,
                decoration: InputDecoration(
                  labelText: 'Transmission Type',
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
                items: ['Automatic', 'Manual'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTransmissionType = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a transmission type' : null,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedSeats,
                decoration: InputDecoration(
                  labelText: 'Seats',
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
                items: ['5', '7'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSeats = value;
                  });
                },
                validator: (value) => value == null ? 'Please select the number of seats' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
                items: ['AVAILABLE', 'UNAVAILABLE'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a status' : null,
              ),
              SizedBox(height: 20),
              Text(
                'Overview',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Description',
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Please enter the description' : null,
              ),
              SizedBox(height: 20),
              // Promotion switch and percentage input
              SwitchListTile(
                title: Text('Promotion'),
                value: _promotion,
                onChanged: (bool value) {
                  setState(() {
                    _promotion = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _percentageController,
                decoration: InputDecoration(
                  labelText: 'Percentage',
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (_promotion && (value == null || value.isEmpty)) {
                    return 'Please enter the discount percentage';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 200, // Set the desired width here
                  child: ElevatedButton(
                    onPressed: _saveCar,
                    child: Text(widget.carDetails == null ? 'Add Now' : 'Save', style: TextStyle(fontSize: 18, color: Colors.white)), // Match the text style
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4550AA), // Use the color 4550AA
                      padding: EdgeInsets.symmetric(vertical: 16), // Match the vertical padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Match the rounded corners
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
