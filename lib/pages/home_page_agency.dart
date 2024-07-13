import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';


class HomePageAgency extends StatefulWidget {
  @override
  _HomePageAgencyState createState() => _HomePageAgencyState();
}

class _HomePageAgencyState extends State<HomePageAgency> {
  final PanelController _panelController = PanelController();

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

  double panelPosition = -1; // Hidden position

  // void toggleFilterPanel() {
  //   if (_panelController.isPanelClosed) {
  //     _panelController.open();
  //   } else {
  //     _panelController.close();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 28),
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
                            'Casablanca',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Icon(Icons.notifications_none, color: Colors.black),
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
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // IconButton(
                              //   icon: Icon(Icons.filter_list),
                              //   // onPressed: toggleFilterPanel,
                              // ),
                              SizedBox(width: 17),
                              ChoiceChip(label: Text('Sedan'), selected: false),
                              SizedBox(width: 17),
                              ChoiceChip(label: Text('Hatchback'), selected: false),
                              SizedBox(width: 17),
                              ChoiceChip(label: Text('Suv'), selected: false),
                              SizedBox(width: 17),
                              ChoiceChip(label: Text('Van'), selected: false),
                              SizedBox(width: 17),
                              ChoiceChip(label: Text('Economy'), selected: false),
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
                  buildAddedCarCard('assets/citreon_c3.png', 'Citroen C3', 'Hatchback', 'MAD350'),
                  buildAddedCarCard('assets/citreon_c3.png', 'Citroen C3', 'Hatchback', 'MAD350'),
                  buildAddedCarCard('assets/citreon_c3.png', 'Citroen C3', 'Hatchback', 'MAD350'),
                  buildAddedCarCard('assets/citreon_c3.png', 'Citroen C3', 'Hatchback', 'MAD350'),
                  buildAddedCarCard('assets/citreon_c3.png', 'Citroen C3', 'Hatchback', 'MAD350'),
                ],
              ),
            ),
          ),
          // SlidingUpPanel(
          //   controller: _panelController,
          //   panel: ,
          //   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          //   minHeight: 0, // Ensure the panel starts hidden
          //   maxHeight: MediaQuery.of(context).size.height * 0.84,
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add car action
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
              // Navigator.pushNamed(context, '/cars'); // Add this route if it exists
              break;
            case 2:
              // Navigator.pushNamed(context, '/bookings'); // Add this route if it exists
              break;
            case 3:
              // Navigator.pushNamed(context, '/profile'); // Navigate to ProfilePage
              break;
          }
        },
      ),
    );
  }

  Widget buildAddedCarCard(String imagePath, String title, String type, String price) {
    return GestureDetector(
      onTap: () {
        
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
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
            contentPadding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 16.0),
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
                Text(type, style: TextStyle(fontSize: 16)),
                SizedBox(height: 3),
                Text('$price/day', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Edit car action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Delete car action
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
