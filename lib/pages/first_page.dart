import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  final VoidCallback skipAction;

  FirstPage({required this.skipAction});

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
                  'Start Your Journey with Bghit Nsog',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Unlock the Road to Adventure',
                  style: TextStyle(
                    color: Colors.grey, // Change second paragraph text color
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
