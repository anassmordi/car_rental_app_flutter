import 'package:flutter/material.dart';

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/mercedes-e-class-3066396_640 1.png',
              fit: BoxFit.contain, // Adjust the image to fit within the boundaries
              alignment: Alignment.center,
            ),
          ),
          Positioned(
            top: 80,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book a car',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Seamless booking experiences: your journey begins with a simple tap',
                  style: TextStyle(
                    color: Colors.grey, // Change second paragraph text color
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 50,
            right: 50,
            child: Center(
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF3B5998), // Use the exact color as provided
                  borderRadius: BorderRadius.circular(5), // Keep the original radius
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/new_account'); // Navigate to new account page
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
