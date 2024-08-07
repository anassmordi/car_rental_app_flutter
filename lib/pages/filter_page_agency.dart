import 'package:flutter/material.dart';
import 'results_page_agency.dart';

class FilterSliderAgency extends StatefulWidget {
  final ScrollController scrollController;
  final List<dynamic> cars; // Add this line
  final Function(List<dynamic>) onFilterApplied; // Add this line

  FilterSliderAgency({required this.scrollController, required this.cars, required this.onFilterApplied}); // Modify constructor

  @override
  _FilterSliderAgencyState createState() => _FilterSliderAgencyState();
}

class _FilterSliderAgencyState extends State<FilterSliderAgency> {
  String selectedBrand = '';
  String selectedModel = '';
  String selectedType = '';
  String selectedTransmission = '';
  String selectedFuel = '';
  double priceRange = 250;

  final Map<String, List<String>> carModels = {
    'BMW': ['1 Series', '3 Series', '5 Series', '7 Series', 'X1', 'X3', 'X5'],
    'Renault': ['Clio', 'Megane', 'Captur', 'Kadjar', 'Scenic'],
    'Dacia': ['Duster', 'Logan', 'Sandero'],
    'Mercedes': ['A-Class', 'C-Class', 'E-Class', 'S-Class', 'GLA', 'GLC', 'GLE'],
    'Volvo': ['XC40', 'XC60', 'XC90', 'S60', 'S90'],
    'Toyota': ['Camry', 'Corolla', 'Highlander', 'RAV4', 'Yaris'],
    'Honda': ['Accord', 'Civic', 'CR-V', 'Fit', 'HR-V'],
    'Ford': ['Escape', 'Explorer', 'F-150', 'Focus', 'Mustang'],
    'Chevrolet': ['Blazer', 'Camaro', 'Equinox', 'Malibu', 'Tahoe'],
    'Nissan': ['Altima', 'Maxima', 'Rogue', 'Sentra', 'Versa'],
    'Hyundai': ['Elantra', 'Kona', 'Palisade', 'Santa Fe', 'Sonata'],
    'Kia': ['Forte', 'Optima', 'Sorento', 'Soul', 'Sportage'],
    'Volkswagen': ['Atlas', 'Golf', 'Jetta', 'Passat', 'Tiguan'],
    'Audi': ['A3', 'A4', 'A6', 'Q5', 'Q7'],
    'Mazda': ['CX-3', 'CX-5', 'CX-9', 'Mazda3', 'Mazda6'],
    'Citroen': ['C3', 'C4', 'C5', 'Berlingo', 'DS3']
  };

  void clearAllSelections() {
    setState(() {
      selectedBrand = '';
      selectedModel = '';
      selectedType = '';
      selectedTransmission = '';
      selectedFuel = '';
      priceRange = 250;
    });
  }

  void applyFilters() {
    List<dynamic> filteredCars = widget.cars;

    if (selectedBrand.isNotEmpty) {
      filteredCars = filteredCars.where((car) => car['make'] == selectedBrand).toList();
    }

    if (selectedModel.isNotEmpty) {
      filteredCars = filteredCars.where((car) => car['model'] == selectedModel).toList();
    }

    if (selectedType.isNotEmpty) {
      filteredCars = filteredCars.where((car) => car['type'] == selectedType).toList();
    }

    if (selectedTransmission.isNotEmpty) {
      filteredCars = filteredCars.where((car) => car['transmissionType'] == selectedTransmission).toList();
    }

    if (selectedFuel.isNotEmpty) {
      filteredCars = filteredCars.where((car) => car['fuelType'] == selectedFuel).toList();
    }

    if (priceRange > 250) {
      filteredCars = filteredCars.where((car) => car['price'] <= priceRange).toList();
    }

    widget.onFilterApplied(filteredCars);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
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
      child: SingleChildScrollView(
        controller: widget.scrollController,
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  buildCustomChip('BMW', 'assets/BMW.png', selectedBrand == 'BMW', () {
                    setState(() {
                      selectedBrand = 'BMW';
                      selectedModel = ''; // Reset the model when the brand changes
                    });
                  }),
                  SizedBox(width: 12),
                  buildCustomChip('Mercedes', 'assets/Mercedes.png', selectedBrand == 'Mercedes', () {
                    setState(() {
                      selectedBrand = 'Mercedes';
                      selectedModel = ''; // Reset the model when the brand changes
                    });
                  }),
                  SizedBox(width: 12),
                  buildCustomChip('Volvo', 'assets/Volvo.png', selectedBrand == 'Volvo', () {
                    setState(() {
                      selectedBrand = 'Volvo';
                      selectedModel = ''; // Reset the model when the brand changes
                    });
                  }),
                  SizedBox(width: 12),
                  buildCustomChip('Dacia', 'assets/Dacia.png', selectedBrand == 'Dacia', () {
                    setState(() {
                      selectedBrand = 'Dacia';
                      selectedModel = ''; // Reset the model when the brand changes
                    });
                  }),
                  SizedBox(width: 12),
                  buildCustomChip('Renault', 'assets/Renault.png', selectedBrand == 'Renault', () {
                    setState(() {
                      selectedBrand = 'Renault';
                      selectedModel = ''; // Reset the model when the brand changes
                    });
                  }),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text('Model', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            DropdownButton<String>(
              isExpanded: true,
              hint: Text('Select car model'),
              value: selectedModel.isNotEmpty ? selectedModel : null,
              items: selectedBrand.isNotEmpty
                  ? carModels[selectedBrand]!.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                  : [],
              onChanged: (value) {
                setState(() {
                  selectedModel = value!;
                });
              },
            ),
            SizedBox(height: 30),
            Text('Types', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                buildCustomChip('Sedan', '', selectedType == 'Sedan', () {
                  setState(() {
                    selectedType = 'Sedan';
                  });
                }),
                buildCustomChip('Economy', '', selectedType == 'Economy', () {
                  setState(() {
                    selectedType = 'Economy';
                  });
                }),
                buildCustomChip('Coupe', '', selectedType == 'Coupe', () {
                  setState(() {
                    selectedType = 'Coupe';
                  });
                }),
                buildCustomChip('Van', '', selectedType == 'Van', () {
                  setState(() {
                    selectedType = 'Van';
                  });
                }),
                buildCustomChip('Hatchback', '', selectedType == 'Hatchback', () {
                  setState(() {
                    selectedType = 'Hatchback';
                  });
                }),
                buildCustomChip('Suv', '', selectedType == 'Suv', () {
                  setState(() {
                    selectedType = 'Suv';
                  });
                }),
                buildCustomChip('Luxury', '', selectedType == 'Luxury', () {
                  setState(() {
                    selectedType = 'Luxury';
                  });
                }),
              ],
            ),
            SizedBox(height: 30),
            Text('Transmission Types', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                buildCustomChip('Any', '', selectedTransmission == '', () {
                  setState(() {
                    selectedTransmission = '';
                  });
                }),
                buildCustomChip('Manual', '', selectedTransmission == 'Manual', () {
                  setState(() {
                    selectedTransmission = 'Manual';
                  });
                }),
                buildCustomChip('Automatic', '', selectedTransmission == 'Automatic', () {
                  setState(() {
                    selectedTransmission = 'Automatic';
                  });
                }),
                buildCustomChip('CVT', '', selectedTransmission == 'CVT', () {
                  setState(() {
                    selectedTransmission = 'CVT';
                  });
                }),
              ],
            ),
            SizedBox(height: 30),
            Text('Fuel Types', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                buildCustomChip('Diesel', '', selectedFuel == 'Diesel', () {
                  setState(() {
                    selectedFuel = 'Diesel';
                  });
                }),
                buildCustomChip('Gas', '', selectedFuel == 'Gas', () {
                  setState(() {
                    selectedFuel = 'Gas';
                  });
                }),
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
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    ),
                    child: Text(
                      'Clear all',
                      style: TextStyle(
                        color: Color(0xFF4550AA),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 35),
                Expanded(
                  child: ElevatedButton(
                    onPressed: applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4550AA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    ),
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomChip(String label, String assetPath, bool isSelected, VoidCallback onSelected) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: 90,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.white,
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            if (assetPath.isNotEmpty)
              Image.asset(assetPath, height: 40, fit: BoxFit.contain),
            Text(label, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
