import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart'; // Add import for LoginPage
import 'package:bghit_nsog/pages/privacy_policy_page.dart'; // Import the Privacy Policy page

class ProfilePageAgency extends StatefulWidget {
  @override
  _ProfilePageAgencyState createState() => _ProfilePageAgencyState();
}

class _ProfilePageAgencyState extends State<ProfilePageAgency> {
  String? agencyName;

  @override
  void initState() {
    super.initState();
    fetchAgencyName();
  }

  Future<void> fetchAgencyName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      agencyName = prefs.getString('userName');
    });
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('userName');
    await prefs.remove('userRole');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFF8F8F8),
          title: Text('Logout', style: TextStyle(color: Colors.black)),
          content: Text('Are you sure you want to logout?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout', style: TextStyle(color: Colors.black)),
              onPressed: () {
                logout(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      body: Padding(
        padding: const EdgeInsets.only(top: 0), // Adjust the top padding as needed
        child: Column(
          children: [
            AppBar(
              centerTitle: true,
              title: Text('Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Color(0xFFF8F8F8),
              elevation: 0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: AssetImage('assets/agency_pfp.jpg'),
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
                      SizedBox(height: 10),
                      Text(
                        agencyName ?? 'Loading...', // Display the agency's name or a loading indicator
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '5',
                        style: TextStyle(fontSize: 22, color: Colors.blue),
                      ),
                      Text(
                        'Total bookings',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      SizedBox(height: 15),
                      buildProfileOption(Icons.history, 'Booking History', context),
                      Divider(),
                      buildProfileOption(Icons.payment, 'Payment Methods', context),
                      Divider(),
                      buildProfileOption(Icons.privacy_tip, 'Privacy Policy', context),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.logout, color: Colors.black),
                        title: Text('Logout', style: TextStyle(fontSize: 18)),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
                        onTap: () => showLogoutConfirmationDialog(context),
                      ),
                    ],
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
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        currentIndex: 3, // Set to Profile
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/homePageAgency');
          } else if (index == 1) {
            // Navigator.pushNamed(context, '/cars'); // Add this route if it exists
          } else if (index == 2) {
            // Navigator.pushNamed(context, '/bookings'); // Add this route if it exists
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profileAgency'); // Navigate to ProfilePageAgency
          }
        },
      ),
    );
  }

  Widget buildProfileOption(IconData icon, String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
        onTap: () {
          if (title == 'Booking History') {
            // Navigate to Booking History page
          } else if (title == 'Payment Methods') {
            // Navigate to Payment Methods page
          } else if (title == 'Privacy Policy') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
            );
          } else {
            // Handle other options if needed
          }
        },
      ),
    );
  }
}
