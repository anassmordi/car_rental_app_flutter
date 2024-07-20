import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'terms_page.dart';

class BookingPage extends StatefulWidget {
  final String carId;
  final String imagePath;
  final String title;
  final String price;

  BookingPage({
    required this.carId,
    required this.imagePath,
    required this.title,
    required this.price,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _pickupDateController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('userName');
    if (userName != null && userName.contains(' ')) {
      List<String> names = userName.split(' ');
      _firstNameController.text = names[0];
      _lastNameController.text = names.length > 1 ? names[1] : '';
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _navigateToTermsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermsPage(
          carId: widget.carId,
          imagePath: widget.imagePath,
          title: widget.title,
          price: widget.price.replaceAll('MAD', '').trim(),
          pickupDate: _pickupDateController.text,
          returnDate: _returnDateController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          cin: _cinController.text,
          phoneNumber: _phoneNumberController.text,
          address: _addressController.text,
        ),
      ),
    );
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
        title: Text('Booking', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Car details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.file(File(widget.imagePath), height: 100, fit: BoxFit.contain),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'MAD ${widget.price.replaceAll('MAD', '').trim()}',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Dates',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Pickup Date',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _pickupDateController,
                      readOnly: true,
                      onTap: () => _selectDate(context, _pickupDateController),
                      decoration: InputDecoration(
                        labelText: 'Select Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey), // Gray border color
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey), // Gray border color for enabled state
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey), // Gray border color for focused state
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Return Date',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _returnDateController,
                      readOnly: true,
                      onTap: () => _selectDate(context, _returnDateController),
                      decoration: InputDecoration(
                        labelText: 'Select Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey), // Gray border color
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey), // Gray border color for enabled state
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey), // Gray border color for focused state
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal info',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey), // Gray border color
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey), // Gray border color for enabled state
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey), // Gray border color for focused state
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey), // Gray border color
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey), // Gray border color for enabled state
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey), // Gray border color for focused state
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey), // Gray border color
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey), // Gray border color for enabled state
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey), // Gray border color for focused state
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _cinController,
                            decoration: InputDecoration(
                              labelText: 'CIN',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey), // Gray border color
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey), // Gray border color for enabled state
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey), // Gray border color for focused state
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    buildPhoneNumberField(),
                    SizedBox(height: 8),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey), // Gray border color
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey), // Gray border color for enabled state
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey), // Gray border color for focused state
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _navigateToTermsPage,
                  child: Center(
                    child: Text(
                      'Next',
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
                    minimumSize: Size(150, 50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPhoneNumberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: IntlPhoneField(
        controller: _phoneNumberController,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey), // Grey border color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey), // Grey border color for enabled state
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey), // Grey border color for focused state
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        initialCountryCode: 'MA',
        onChanged: (phone) {
          // Handle phone number change
        },
      ),
    );
  }
}

class DetailsCheckPage extends StatelessWidget {
  final String carId;
  final String imagePath;
  final String title;
  final String price;
  final String pickupDate;
  final String returnDate;
  final String firstName;
  final String lastName;
  final String email;
  final String cin;
  final String phoneNumber;
  final String address;

  DetailsCheckPage({
    required this.carId,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.pickupDate,
    required this.returnDate,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.cin,
    required this.phoneNumber,
    required this.address,
  });

  void _navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  void _navigateToTermsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermsPage(
          carId: carId,
          imagePath: imagePath,
          title: title,
          price: price.replaceAll('MAD', '').trim(),
          pickupDate: pickupDate,
          returnDate: returnDate,
          firstName: firstName,
          lastName: lastName,
          email: email,
          cin: cin,
          phoneNumber: phoneNumber,
          address: address,
        ),
      ),
    );
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
        title: Text('Details Check', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Car details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.file(File(imagePath), height: 100, fit: BoxFit.contain),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'MAD $price',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text('Receipt date: $pickupDate'),
                    Text('Delivery date: $returnDate'),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal info',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('First Name: $firstName'),
                    Text('Last Name: $lastName'),
                    Text('Email: $email'),
                    Text('CIN: $cin'),
                    Text('Phone Number: $phoneNumber'),
                    Text('Address: $address'),
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _navigateBack(context),
                        child: Text('Previous', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(150, 50),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _navigateToTermsPage(context),
                        child: Center(
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4550AA),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(150, 50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
