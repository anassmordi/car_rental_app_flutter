import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'filter_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'details_page.dart';
import 'car_recommendations_page.dart';
import 'notifications_page.dart'; // Import the Notifications page

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void toggleFilterPanel() {
    if (_panelController.isPanelClosed) {
      _panelController.open();
    } else {
      _panelController.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 28),
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
                      IconButton(
                        icon: Icon(Icons.notifications_none, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NotificationsPage()),
                          );
                        },
                      ),
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
                      IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: toggleFilterPanel,
                      ),
                      SizedBox(width: 17),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ChoiceChip(
                                label: Text('Sedan'),
                                selected: false,
                                backgroundColor: Color(0xFFF8F8F8),
                                selectedColor: Color(0xFFF8F8F8),
                                disabledColor: Color(0xFFF8F8F8),
                              ),
                              SizedBox(width: 17),
                              ChoiceChip(
                                label: Text('Hatchback'),
                                selected: false,
                                backgroundColor: Color(0xFFF8F8F8),
                                selectedColor: Color(0xFFF8F8F8),
                                disabledColor: Color(0xFFF8F8F8),
                              ),
                              SizedBox(width: 17),
                              ChoiceChip(
                                label: Text('Suv'),
                                selected: false,
                                backgroundColor: Color(0xFFF8F8F8),
                                selectedColor: Color(0xFFF8F8F8),
                                disabledColor: Color(0xFFF8F8F8),
                              ),
                              SizedBox(width: 17),
                              ChoiceChip(
                                label: Text('Van'),
                                selected: false,
                                backgroundColor: Color(0xFFF8F8F8),
                                selectedColor: Color(0xFFF8F8F8),
                                disabledColor: Color(0xFFF8F8F8),
                              ),
                              SizedBox(width: 17),
                              ChoiceChip(
                                label: Text('Economy'),
                                selected: false,
                                backgroundColor: Color(0xFFF8F8F8),
                                selectedColor: Color(0xFFF8F8F8),
                                disabledColor: Color(0xFFF8F8F8),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Available cars near you',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        buildCarCard('assets/clio_4.png', 'Renault Clio 4', 'Hatchback', 'MAD300'),
                        buildCarCard('assets/citreon_c3.png', 'Citroen C3', 'Sedan', 'MAD350'),
                        buildCarCard('assets/dacia_duster.png', 'Dacia Duster', 'Sedan', 'MAD350'),
                        buildCarCard('assets/clio_4.png', 'Renault Clio 4', 'Hatchback', 'MAD300'),
                        buildCarCard('assets/citreon_c3.png', 'Citroen C3', 'Sedan', 'MAD350'),
                        buildCarCard('assets/dacia_duster.png', 'Dacia Duster', 'Sedan', 'MAD350'),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Car recommendations',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  buildRecommendationCard('assets/citreon_c3.png', 'Citroen C3', 'Hatchback', 'MAD350'),
                  buildRecommendationCard('assets/audi_a3_sportback.png', 'Audi A3 Sportback', 'Suv', 'MAD500'),
                  buildRecommendationCard('assets/mazda_3.png', 'Mazda Mazda 3', 'Sedan', 'MAD500'),
                  buildRecommendationCard('assets/citreon_c3.png', 'Citroen C3', 'Hatchback', 'MAD350'),
                  buildRecommendationCard('assets/audi_a3_sportback.png', 'Audi A3 Sportback', 'Suv', 'MAD500'),
                  buildRecommendationCard('assets/mazda_3.png', 'Mazda Mazda 3', 'Sedan', 'MAD500'),
                ],
              ),
            ),
          ),
          SlidingUpPanel(
            controller: _panelController,
            panelBuilder: (scrollController) => FilterSlider(
              scrollController: scrollController,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            minHeight: 0, // Ensure the panel starts hidden
            maxHeight: MediaQuery.of(context).size.height * 0.84,
            backdropEnabled: true,
            backdropTapClosesPanel: true,
          ),
        ],
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
              // Navigator.pushReplacementNamed(context, '/homePage');
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CarRecommendationsPage()),
              );
              break;
            case 2:
              Navigator.pushNamed(context, '/rideHistory'); // Add this route if it exists
              break;
            case 3:
              Navigator.pushNamed(context, '/profile'); // Navigate to ProfilePage
              break;
          }
        },
      ),
    );
  }

  Widget buildCarCard(String imagePath, String title, String type, String price) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              imagePath: imagePath,
              title: title,
              type: type,
              price: price,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 13.0, bottom: 10, left: 5),
        child: Container(
          width: 165,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 0.5,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            children: [
              Image.asset(imagePath, height: 95, fit: BoxFit.contain),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      type,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text('$price/day', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRecommendationCard(String imagePath, String title, String type, String price) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              imagePath: imagePath,
              title: title,
              type: type,
              price: price,
            ),
          ),
        );
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
          ),
        ),
      ),
    );
  }
}
