import 'package:flutter/material.dart';

class TermsPage extends StatefulWidget {
  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  bool _isAccepted = false;
  bool _isLoading = false;

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Terms & Conditions"),
          content: Text("You must agree to the terms and conditions to proceed."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 100, color: Colors.green),
              SizedBox(height: 20),
              Text('Information submitted successfully', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );

    // Automatically close the dialog after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/homePage');
    });
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a network call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    _showSuccessDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xFFF8F8F8),
        elevation: 0,
        title: Text('Terms & Conditions', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Text(
                      'Car Rental Terms and Conditions\n\n'
                      '1. **Introduction**\n'
                      'These terms and conditions govern your use of our car rental services. By using our service, you accept these terms in full. If you disagree with any part of these terms, you must not use our service.\n\n'
                      '2. **Rental Period**\n'
                      'The rental period starts at the time the vehicle is delivered to you and ends when the vehicle is returned. Late returns will incur additional charges.\n\n'
                      '3. **Vehicle Condition**\n'
                      'You must return the vehicle in the same condition as when you received it, excluding normal wear and tear. You are responsible for any damage to the vehicle during the rental period.\n\n'
                      '4. **Driver Requirements**\n'
                      'All drivers must hold a valid driving license and meet our age requirements. Additional drivers must be registered and approved by the rental agency.\n\n'
                      '5. **Insurance**\n'
                      'Our rental vehicles come with basic insurance coverage. You may purchase additional insurance for more comprehensive coverage.\n\n'
                      '6. **Fuel Policy**\n'
                      'The vehicle will be provided with a full tank of fuel and must be returned with a full tank. Failure to do so will result in a refueling charge.\n\n'
                      '7. **Mileage Allowance**\n'
                      'Your rental agreement includes a mileage allowance. Excess mileage will be charged at a specified rate.\n\n'
                      '8. **Payment**\n'
                      'Payment must be made in full before the rental period begins. We accept major credit cards and other forms of payment as specified by the rental agency.\n\n'
                      '9. **Cancellations**\n'
                      'Cancellations must be made at least 24 hours before the rental period starts. Late cancellations may incur a fee.\n\n'
                      '10. **Liability**\n'
                      'We are not liable for any indirect or consequential losses arising from the rental of our vehicles. Our maximum liability is limited to the rental amount paid.\n\n'
                      '11. **Governing Law**\n'
                      'These terms are governed by the laws of Morocco. Any disputes will be resolved in the courts of Morocco.\n\n'
                      'By clicking "Agree", you acknowledge that you have read and agree to these terms and conditions.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _isAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      _isAccepted = value ?? false;
                    });
                  },
                ),
                Text('Agree with the ', style: TextStyle(fontSize: 16)),
                Text(
                  'terms & conditions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Previous', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(150, 50),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_isAccepted) {
                            _submit();
                          } else {
                            _showAlertDialog(context);
                          }
                        },
                        child: _isLoading
                            ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Done',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isAccepted ? Color(0xFF4550AA) : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(150, 50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
