import 'package:flutter/material.dart';
import 'home_page.dart';
import 'car_recommendations_page.dart';
import 'profile_page.dart';

class RideHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Color(0xFFF8F8F8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Ride History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildRideHistoryCard('assets/citreon_c3.png', 'Citroen C3', '6 days', 'MAD250'),
              SizedBox(height: 16),
              buildRideHistoryCard('assets/audi_a3_sportback.png', 'Audi A3 Sportback', '3 days', 'MAD600'),
              SizedBox(height: 16),
              buildRideHistoryCard('assets/mazda_3.png', 'Mazda Mazda 3', '14 days', 'MAD500'),
              SizedBox(height: 16),
              buildRideHistoryCard('assets/citreon_c3.png', 'Citroen C3', '6 days', 'MAD250'),
              SizedBox(height: 16),
              buildRideHistoryCard('assets/audi_a3_sportback.png', 'Audi A3 Sportback', '3 days', 'MAD600'),
              SizedBox(height: 16),
              buildRideHistoryCard('assets/mazda_3.png', 'Mazda Mazda 3', '14 days', 'MAD500'),
              SizedBox(height: 16),
              buildRideHistoryCard('assets/citreon_c3.png', 'Citroen C3', '6 days', 'MAD250'),
              SizedBox(height: 16),
              buildRideHistoryCard('assets/audi_a3_sportback.png', 'Audi A3 Sportback', '3 days', 'MAD600'),
              SizedBox(height: 16),
              buildRideHistoryCard('assets/mazda_3.png', 'Mazda Mazda 3', '14 days', 'MAD500'),
              SizedBox(height: 16),
              buildRideHistoryCard('assets/citreon_c3.png', 'Citroen C3', '6 days', 'MAD250'),
              SizedBox(height: 16),
              buildRideHistoryCard('assets/audi_a3_sportback.png', 'Audi A3 Sportback', '3 days', 'MAD600'),
              SizedBox(height: 16),
              buildRideHistoryCard('assets/mazda_3.png', 'Mazda Mazda 3', '14 days', 'MAD500'),
              SizedBox(height: 16),
            ],
          ),
        ),
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
        currentIndex: 2, // Set to Bookings
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CarRecommendationsPage()),
              );
              break;
            case 2:
              // Already on RideHistoryPage
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget buildRideHistoryCard(String imagePath, String title, String duration, String price) {
    return Container(
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
        leading: Image.asset(imagePath, width: 100, height: 60, fit: BoxFit.contain),
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
            Text(duration, style: TextStyle(fontSize: 16)),
            SizedBox(height: 3),
            Text(price, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
