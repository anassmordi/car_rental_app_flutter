import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart'; // Add import for LoginPage

class ProfilePage extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 55.0), // Adjust the top padding as needed
        child: Column(
          children: [
            AppBar(
              centerTitle: true,
              title: Text('Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 28)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 40),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage('assets/profile_pic.jpg'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              // Handle pen icon tap
                              // print("Pen icon tapped");
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Color.fromARGB(255, 235, 235, 235),
                              child: Icon(Icons.edit, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),


                    SizedBox(height: 16),
                    Text(
                      'Anass Mordi',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '3',
                      style: TextStyle(fontSize: 22, color: Colors.blue),
                    ),
                    Text(
                      'Total rides',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(height: 35),
                    buildProfileOption(Icons.history, 'Rides History'),
                    Divider(),
                    buildProfileOption(Icons.payment, 'Payment Methods'),
                    Divider(),
                    buildProfileOption(Icons.privacy_tip, 'Privacy Policy'),
                    Divider(),
                    buildProfileOption(Icons.help, 'Help Center'),
                    Divider(),
                    buildProfileOption(Icons.car_rental, 'Become a Renter'),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.black),
                      title: Text('Logout', style: TextStyle(fontSize: 18)),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
                      onTap: () => logout(context),
                    ),
                  ],
                )

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
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        currentIndex: 3, // Set to Profile
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/homePage');
          } else if (index == 1) {
            // Navigator.pushNamed(context, '/cars'); // Add this route if it exists
          } else if (index == 2) {
            // Navigator.pushNamed(context, '/bookings'); // Add this route if it exists
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profile'); // Navigate to ProfilePage
          }
        },
      ),
    );
  }

  Widget buildProfileOption(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
        onTap: () {
          // Handle option tap
        },
      ),
    );
  }
}
