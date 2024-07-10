import 'package:flutter/material.dart';
import 'pages/first_page.dart';
import 'pages/second_page.dart';
import 'pages/third_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Disable the debug banner
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _skipToLastPage() {
    _pageController.animateToPage(
      2,
      duration: Duration(milliseconds: 150), // Faster transition
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              FirstPage(skipAction: _skipToLastPage),
              SecondPage(skipAction: _skipToLastPage),
              ThirdPage(),
            ],
          ),
          Positioned(
            top: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 150), // Faster transition
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 10,
                      width: _currentPage == index ? 10 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.white : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                TextButton(
                  onPressed: _skipToLastPage,
                  child: Text(
                    'Skip',
                    style: TextStyle(color: Colors.grey), // Change skip text color
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
