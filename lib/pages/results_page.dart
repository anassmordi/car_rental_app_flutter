import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Results',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              // Add filter action here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Special offers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Container(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildOfferCard(
                      'assets/peugeot.png',
                      'Peugeot 208',
                      'Hatchback',
                      'MAD350',
                      '20%',
                    ),
                    buildOfferCard(
                      'assets/renault.png',
                      'Renault Clio',
                      'Hatchback',
                      'MAD250',
                      '20%',
                    ),
                    buildOfferCard(
                      'assets/dacia.png',
                      'Dacia Duster',
                      'Hatchback',
                      'MAD450',
                      '20%',
                    ),
                    // Add more OfferCards here
                    buildOfferCard(
                      'assets/volkswagen.png',
                      'Volkswagen Golf',
                      'Hatchback',
                      'MAD500',
                      '20%',
                    ),
                    buildOfferCard(
                      'assets/toyota.png',
                      'Toyota Yaris',
                      'Hatchback',
                      'MAD300',
                      '20%',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Filter results',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              buildFilterResultCard(
                'assets/volkswagen.png',
                'Volkswagen Golf',
                'MAD500/day',
              ),
              buildFilterResultCard(
                'assets/volkswagen.png',
                'Volkswagen Golf',
                'MAD500/day',
              ),
              buildFilterResultCard(
                'assets/volkswagen.png',
                'Volkswagen Golf',
                'MAD500/day',
              ),
              buildFilterResultCard(
                'assets/volkswagen.png',
                'Volkswagen Golf',
                'MAD500/day',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOfferCard(
    String imagePath,
    String title,
    String type,
    String price,
    String discount,
  ) {
    return Padding(
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset(imagePath, height: 120, fit: BoxFit.contain)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(type, style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 4),
                      Text('$price/day', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF4550AA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  discount,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterResultCard(
    String imagePath,
    String title,
    String price,
  ) {
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
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 16.0),
          leading: Image.asset(imagePath, width: 120, height: 80, fit: BoxFit.contain),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Text(price, style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}

class CarCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final VoidCallback onTap;

  CarCard({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: Colors.blue,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(imageUrl, height: 100, width: 150, fit: BoxFit.cover),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(price),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  final String price;
  final String? discount;
  final String? company;

  DetailPage({required this.title, required this.price, this.discount, this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: $price', style: TextStyle(fontSize: 18)),
            if (discount != null) ...[
              SizedBox(height: 8),
              Text('Discount: $discount', style: TextStyle(fontSize: 18)),
            ],
            if (company != null) ...[
              SizedBox(height: 8),
              Text('Company: $company', style: TextStyle(fontSize: 18)),
            ],
          ],
        ),
      ),
    );
  }
}
