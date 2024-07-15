import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String type;
  final String price;

  DetailsPage({
    required this.imagePath,
    required this.title,
    required this.type,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8), // Update background color
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xFFF8F8F8),
        elevation: 0,
        title: Text('Details', style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 24)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(imagePath, height: 200, fit: BoxFit.contain),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      type,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'MAD',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(
                          text: price.replaceAll('MAD', ''),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(
                          text: '/day',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  buildFeatureChip(Icons.local_gas_station, 'Petrol'),
                  buildFeatureChip(Icons.settings, 'Auto'),
                  buildFeatureChip(Icons.airline_seat_recline_normal, '5'),
                  buildFeatureChip(Icons.ac_unit, 'AC'),
                  buildFeatureChip(Icons.speed, '120/km'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Lorem ipsum dolor sit amet consectetur. Auctor imperdiet lorem vitae aliquet. '
              'Tincidunt sed mauris ac quis lobortis blandit ullamcorper scelerisque. '
              'Integer malesuada elit iaculis donec vitae feugiat fermentum ut habitant. '
              'Gravida tortor cras ac nulla ut sed porta viverra euismod. '
              'Sit facilisi mi elementum.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: 200, // Specify the width you want
                child: ElevatedButton(
                  onPressed: () {},
                  child: Center(
                    child: Text(
                      'Book Now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4550AA), // button background color
                    foregroundColor: Colors.white, // text color
                    padding: EdgeInsets.symmetric(vertical: 20.0), // Adjust padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // less rounded corners
                    ),
                    minimumSize: Size(0, 50), // height of the button
                  ),
                ),
              ),
            ),
          ],
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
        currentIndex: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/homePage');
              break;
            case 1:
              // Navigator.pushNamed(context, '/cars'); // Add this route if it exists
              break;
            case 2:
              // Navigator.pushNamed(context, '/bookings'); // Add this route if it exists
              break;
            case 3:
              Navigator.pushNamed(context, '/profile'); // Navigate to ProfilePage
              break;
          }
        },
      ),
    );
  }

  Widget buildFeatureChip(IconData iconData, String label) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10), // Increased margin
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(iconData, color: Colors.black),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
