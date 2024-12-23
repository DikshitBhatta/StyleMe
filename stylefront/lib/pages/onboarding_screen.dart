import 'package:flutter/material.dart';
import 'sign_in_screen.dart';
import '../widgets/splash_painter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Onboarding data with colors
  final List<Map<String, dynamic>> onboardingData = [
    {
      'colors': [Color(0xFF4158D0), Color(0xFFC850C0), Color(0xFFFFCC70)],
      'title': 'Explore Our World',
      'subtitle': 'Find the cleanest and hottest styles from the brands you love.',
      'icon': Icons.explore,
    },
    {
      'colors': [Color(0xFF0093E9), Color(0xFF80D0C7)],
      'title': 'AI Integration',
      'subtitle': 'Use StyleMe to get the best fit recommendation and try-on image.',
      'icon': Icons.smart_toy,
    },
    {
      'colors': [Color(0xFFFF3CAC), Color(0xFF784BA0), Color(0xFF2B86C5)],
      'title': 'Happy Shopping',
      'subtitle': 'Experience over thousands of stylish products in StyleMe.',
      'icon': Icons.shopping_bag,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated Background
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: SplashPainter(
                  animationValue: _animation.value,
                  color: onboardingData[_currentPage]['colors'][0],
                  center: Offset(
                    MediaQuery.of(context).size.width / 2,
                    MediaQuery.of(context).size.height / 2,
                  ),
                ),
                child: Container(),
              );
            },
          ),
          // Content
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) => _buildPage(index),
                ),
              ),
              // Pagination Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (index) => _buildDot(index),
                ),
              ),
              SizedBox(height: 20),
              _buildButton(),
              SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + (_animation.value * 0.2),
                  child: Icon(
                    onboardingData[index]['icon'],
                    size: 100,
                    color: Colors.white.withOpacity(_animation.value),
                  ),
                );
              },
            ),
            SizedBox(height: 40),
            Text(
              onboardingData[index]['title'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              onboardingData[index]['subtitle'],
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.white38,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          if (_currentPage == onboardingData.length - 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          } else {
            _pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          _currentPage == onboardingData.length - 1 ? 'Get Started' : 'Next',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}