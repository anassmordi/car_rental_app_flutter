import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'details_page.dart';
import 'filter_page.dart';

class ResultsPage extends StatelessWidget {
  final PanelController _panelController = PanelController();

  void toggleFilterPanel(BuildContext context) {
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
          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 24),
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
                  Container(
                    height: 220,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        buildOfferCard(
                          context,
                          'assets/clio_4.png',
                          'Renault Clio 4',
                          'Hatchback',
                          'MAD300',
                          '20%',
                        ),
                        buildOfferCard(
                          context,
                          'assets/citreon_c3.png',
                          'Citroen C3',
                          'Sedan',
                          'MAD350',
                          '20%',
                        ),
                        buildOfferCard(
                          context,
                          'assets/dacia_duster.png',
                          'Dacia Duster',
                          'Sedan',
                          'MAD350',
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
                  buildRecommendationCard(context, 'assets/citreon_c3.png', 'Citroen C3', 'Hatchback', 'MAD350'),
                  buildRecommendationCard(context, 'assets/audi_a3_sportback.png', 'Audi A3 Sportback', 'Suv', 'MAD500'),
                  buildRecommendationCard(context, 'assets/mazda_3.png', 'Mazda Mazda 3', 'Sedan', 'MAD500'),
                  buildRecommendationCard(context, 'assets/citreon_c3.png', 'Citroen C3', 'Hatchback', 'MAD350'),
                  buildRecommendationCard(context, 'assets/audi_a3_sportback.png', 'Audi A3 Sportback', 'Suv', 'MAD500'),
                  buildRecommendationCard(context, 'assets/mazda_3.png', 'Mazda Mazda 3', 'Sedan', 'MAD500'),
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
    String imagePath,
    String title,
    String type,
    String price,
    String discount,
  ) {
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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset(imagePath, height: 100, width: 150, fit: BoxFit.contain)),
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

  Widget buildRecommendationCard(BuildContext context, String imagePath, String title, String type, String price) {
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
