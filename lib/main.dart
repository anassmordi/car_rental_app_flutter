import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/first_page.dart';
import 'pages/second_page.dart';
import 'pages/third_page.dart';
import 'pages/new_account_page.dart';
import 'pages/login_page.dart';
import 'splash_screen.dart';
import 'pages/home_page.dart';
import 'pages/details_page.dart';
import 'pages/home_page_agency.dart';
import 'pages/profile_page_agency.dart';
import 'pages/details_page_agency.dart';
// import 'pages/results_page.dart';
import 'pages/ride_history_page.dart';
import 'pages/registration_page.dart';
import 'pages/car_form_page.dart';
import 'pages/become_agency_page.dart';
import 'pages/agency_cars_page.dart';
import 'pages/profile_page.dart';
import 'pages/results_page_agency.dart';
import 'pages/booking_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');
  String? refreshToken = prefs.getString('refreshToken');
  String? role = prefs.getString('userRole');

  runApp(MyApp(
    isLoggedIn: accessToken != null && refreshToken != null,
    role: role,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? role;

  MyApp({required this.isLoggedIn, this.role});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF8F8F8),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(isLoggedIn: isLoggedIn, role: role),
        '/home': (context) => OnboardingScreen(),
        '/new_account': (context) => NewAccountPage(),
        '/login': (context) => LoginPage(),
        '/homePage': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/details': (context) => DetailsPage(
          carId: '',
        ),
        '/homePageAgency': (context) => HomePageAgency(),
        '/profileAgency': (context) => ProfilePageAgency(),
        '/detailsAgency': (context) => DetailsPageAgency(
          carId: '',
        ),
        '/rideHistory': (context) => RideHistoryPage(),
        '/registration': (context) => RegistrationPage(),
        '/carForm': (context) => CarFormPage(),
        '/becomeAgency': (context) => BecomeAgencyPage(),
        '/agencyCars': (context) => AgencyCarsPage(),
         '/resultsAgency': (context) => ResultsPageAgency(
          carsWithPromotions: [],
          otherCars: [],
           allCars:[]
        ), 
        '/booking': (context) => BookingPage(carId: '',imagePath: '',title: '',price: '',),
      },
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
      duration: Duration(milliseconds: 150),
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
                      duration: Duration(milliseconds: 150),
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
                    style: TextStyle(color: Colors.grey),
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
