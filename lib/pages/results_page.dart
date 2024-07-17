import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'details_page.dart';
import 'filter_page.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path/path.dart' as p;

class ResultsPage extends StatelessWidget {
  final PanelController _panelController = PanelController();
  final List<dynamic> carsWithPromotions;
  final List<dynamic> otherCars;

  ResultsPage({required this.carsWithPromotions, required this.otherCars});

  void toggleFilterPanel(BuildContext context) {
    if (_panelController.isPanelClosed) {
      _panelController.open();
    } else {
      _panelController.close();
    }
  }

  Future<Uint8List> _fetchImage(String imageName) async {
    try {
      final correctedImageName = imageName.replaceFirst(RegExp(r'^images\\cars\\'), '');
      final filePath = p.join('C:\\Users\\anass\\Documents\\', correctedImageName);
      final file = File(filePath);
      if (await file.exists()) {
        return file.readAsBytes();
      } else {
        throw Exception('Image not found');
      }
    } catch (e) {
      throw Exception('Failed to load image');
    }
  }

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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              toggleFilterPanel(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                  if (carsWithPromotions.isNotEmpty)
                    Container(
                      height: 220,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: carsWithPromotions.map((car) => buildOfferCard(
                          context,
                          car['id'],
                          car['imageFileNames'][0],
                          car['make'] + ' ' + car['model'],
                          car['type'],
                          'MAD${car['price']}',
                          '${car['percentage']}%',
                        )).toList(),
                      ),
                    )
                  else
                    Text('No special offers available'),
                  SizedBox(height: 16),
                  Text(
                    'Filter results',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  if (otherCars.isNotEmpty)
                    Column(
                      children: otherCars.map((car) => buildRecommendationCard(
                        context,
                        car['id'],
                        car['imageFileNames'][0],
                        car['make'] + ' ' + car['model'],
                        car['type'],
                        'MAD${car['price']}',
                      )).toList(),
                    )
                  else
                    Text('No results found'),
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
    );
  }

  Widget buildOfferCard(
    BuildContext context,
    String carId,
    String imagePath,
    String title,
    String type,
    String price,
    String discount,
  ) {
    final correctedImageName = imagePath.replaceFirst(RegExp(r'^images\\cars\\'), '');
    final filePath = p.join('C:\\Users\\anass\\Documents\\', correctedImageName);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(carId: carId), // Pass only carId
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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: FutureBuilder<Uint8List>(
                    future: _fetchImage(imagePath),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Icon(Icons.error);
                      } else {
                        return Image.memory(snapshot.data!, height: 100, width: 150, fit: BoxFit.contain);
                      }
                    },
                  )),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
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
      ),
    );
  }

  Widget buildRecommendationCard(BuildContext context, String carId, String imagePath, String title, String type, String price) {
    final correctedImageName = imagePath.replaceFirst(RegExp(r'^images\\cars\\'), '');
    final filePath = p.join('C:\\Users\\anass\\Documents\\', correctedImageName);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(carId: carId), // Pass only carId
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
            leading: FutureBuilder<Uint8List>(
              future: _fetchImage(imagePath),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Icon(Icons.error);
                } else {
                  return Image.memory(snapshot.data!, width: 100, height: 60, fit: BoxFit.contain);
                }
              },
            ),
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
