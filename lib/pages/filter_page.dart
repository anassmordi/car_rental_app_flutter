import 'package:flutter/material.dart';

class FilterSlider extends StatefulWidget {
  @override
  _FilterSliderState createState() => _FilterSliderState();
}

class _FilterSliderState extends State<FilterSlider> {
  String selectedBrand = '';
  String selectedType = '';
  String selectedTransmission = '';
  String selectedFuel = '';
  double priceRange = 250;

  void clearAllSelections() {
    setState(() {
      selectedBrand = '';
      selectedType = '';
      selectedTransmission = '';
      selectedFuel = '';
      priceRange = 250;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Search for a car',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text('Brands', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              buildBrandCard('BMW', 'assets/BMW.png'),
              buildBrandCard('Mercedes', 'assets/Mercedes.png'),
              buildBrandCard('Volvo', 'assets/Volvo.png'),
              buildBrandCard('Dacia', 'assets/Dacia.png'),
              buildBrandCard('Renault', 'assets/Renault.png'),
            ],
          ),
          SizedBox(height: 30),
          Text('Model', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          DropdownButton<String>(
            isExpanded: true,
            hint: Text('Select car model'),
            items: <String>['Model A', 'Model B', 'Model C'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
          SizedBox(height: 30),
          Text('Types', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              buildTypeCard('Sedan'),
              buildTypeCard('Economy'),
              buildTypeCard('Coupe'),
              buildTypeCard('Van'),
              buildTypeCard('Hatchback'),
              buildTypeCard('Suv'),
              buildTypeCard('Luxury'),
            ],
          ),
          SizedBox(height: 30),
          Text('Transmission Types', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              buildTransmissionCard('Any'),
              buildTransmissionCard('Manual'),
              buildTransmissionCard('Automatic'),
              buildTransmissionCard('CVT'),
            ],
          ),
          SizedBox(height: 30),
          Text('Fuel Types', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              buildFuelCard('Diesel'),
              buildFuelCard('Gas'),
            ],
          ),
          SizedBox(height: 30),
          Text('Price Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Row(
            children: [
              Text('MAD${priceRange.toStringAsFixed(0)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Expanded(
                child: Slider(
                  value: priceRange,
                  min: 250,
                  max: 3000,
                  onChanged: (value) {
                    setState(() {
                      priceRange = value;
                    });
                  },
                ),
              ),
              Text('MAD3000', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
          Spacer(),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: clearAllSelections,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF4550AA), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                  ),
                  child: Text(
                    'Clear all',
                    style: TextStyle(
                      color: Color(0xFF4550AA),
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
              ),
              SizedBox(width: 35),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4550AA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                  ),
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBrandCard(String brand, String assetPath) {
    return ChoiceChip(
      label: Column(
        children: [
          Image.asset(assetPath, height: 40, fit: BoxFit.contain),
          Text(brand, style: TextStyle(fontSize: 12)),
        ],
      ),
      selected: selectedBrand == brand,
      onSelected: (bool selected) {
        setState(() {
          selectedBrand = brand;
        });
      },
      selectedColor: Colors.blue.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: selectedBrand == brand ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }

  Widget buildTypeCard(String type) {
    return ChoiceChip(
      label: Text(type),
      selected: selectedType == type,
      onSelected: (bool selected) {
        setState(() {
          selectedType = type;
        });
      },
      selectedColor: Colors.blue.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: BorderSide(
          color: selectedType == type ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }

  Widget buildTransmissionCard(String transmission) {
    return ChoiceChip(
      label: Text(transmission),
      selected: selectedTransmission == transmission,
      onSelected: (bool selected) {
        setState(() {
          selectedTransmission = transmission;
        });
      },
      selectedColor: Colors.blue.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: BorderSide(
          color: selectedTransmission == transmission ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }

  Widget buildFuelCard(String fuel) {
    return ChoiceChip(
      label: Text(fuel),
      selected: selectedFuel == fuel,
      onSelected: (bool selected) {
        setState(() {
          selectedFuel = fuel;
        });
      },
      selectedColor: Colors.blue.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: BorderSide(
          color: selectedFuel == fuel ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}
