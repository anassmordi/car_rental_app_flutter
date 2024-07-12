import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
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
  Widget buildChoiceChip(String label) {
  return ChoiceChip(
    label: Text(label),
    selected: false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    backgroundColor: Colors.white,
    labelStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.black), // Added location icon
                      SizedBox(width: 8), // Added space between icon and text
                      Text(
                        'Casablanca',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Icon(Icons.notifications_none, color: Colors.black), // Adjust icon color if needed
                ],
              ),
      SizedBox(height: 16),
      TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey), // Adjust icon color
          // Adjust icon color and use appropriate icon
          hintText: 'Search cars by brand',
          hintStyle: TextStyle(color: Colors.grey), // Adjust hint text color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0), // Adjust border radius
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200], // Adjust fill color
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
                              IconButton(
                                icon: Icon(Icons.filter_list),
                                onPressed: () {
                                  // Handle filter action
                                },
                              ),
                              SizedBox(width: 17),  // Increased space between filter icon and first chip
                              ChoiceChip(
                                label: Text('Sedan'),
                                selected: false,
                                onSelected: (bool selected) {
                                  // Handle chip selection
                                },
                              ),
                              SizedBox(width: 17),  // Increased space between chips
                              ChoiceChip(
                                label: Text('Hatchback'),
                                selected: false,
                                onSelected: (bool selected) {
                                  // Handle chip selection
                                },
                              ),
                              SizedBox(width: 17),  // Increased space between chips
                              ChoiceChip(
                                label: Text('Suv'),
                                selected: false,
                                onSelected: (bool selected) {
                                  // Handle chip selection
                                },
                              ),
                              SizedBox(width: 17),  // Increased space between chips
                              ChoiceChip(
                                label: Text('Van'),
                                selected: false,
                                onSelected: (bool selected) {
                                  // Handle chip selection
                                },
                              ),
                              SizedBox(width: 17),  // Increased space between chips
                              ChoiceChip(
                                label: Text('Econonmy'),
                                selected: false,
                                onSelected: (bool selected) {
                                  // Handle chip selection
                                },
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
                    buildCarCard('assets/clio_4.png', 'Renault Clio 4', 'Hatchback', 'MAD300/day'),
                    buildCarCard('assets/citreon_c3.png', 'Citroen C3', 'Sedan', 'MAD350/day'),
                    buildCarCard('assets/dacia_duster.png', 'Dacia Duster', 'Sedan', 'MAD350/day'),
                    buildCarCard('assets/clio_4.png', 'Renault Clio 4', 'Hatchback', 'MAD300/day'),
                    buildCarCard('assets/citreon_c3.png', 'Citroen C3', 'Sedan', 'MAD350/day'),
                    buildCarCard('assets/dacia_duster.png', 'Dacia Duster', 'Sedan', 'MAD350/day'),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Car recommendations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              buildRecommendationCard('assets/citreon_c3.png', 'Citroen C3', 'Hatchback', 'MAD350/day'),
              buildRecommendationCard('assets/audi_a3_sportback.png', 'Audi A3 Sportback', 'Suv', 'MAD500/day'),
              buildRecommendationCard('assets/mazda_3.png', 'Mazda Mazda 3', 'Sedan', 'MAD500/day'),
              buildRecommendationCard('assets/citreon_c3.png', 'Citroen C3', 'Hatchback', 'MAD350/day'),
              buildRecommendationCard('assets/audi_a3_sportback.png', 'Audi A3 Sportback', 'Suv', 'MAD500/day'),
              buildRecommendationCard('assets/mazda_3.png', 'Mazda Mazda 3', 'Sedan', 'MAD500/day'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Ensure labels are shown for all items
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
          selectedItemColor: Colors.black, // Set color for selected item
          unselectedItemColor: Colors.grey, // Set color for unselected items
          backgroundColor: Colors.white, // Set background color
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

  Widget buildCarCard(String imagePath, String title, String type, String price) {
    return Padding(
      padding: const EdgeInsets.only(right: 13.0),
      child: Container(
        width: 165,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
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
                  Text(price, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget buildRecommendationCard(String imagePath, String title, String type, String price) {
    return Padding(
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
              offset: Offset(0, 3), // changes position of shadow
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
              Text(price, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }


}
