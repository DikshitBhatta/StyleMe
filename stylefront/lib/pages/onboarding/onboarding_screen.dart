import 'package:flutter/material.dart';
import 'package:stylefront/pages/authentication/signin.dart';
import 'package:stylefront/widgets/wave_painter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _previousPage = 0; // Track the previous page
  late AnimationController _animationController1;
  late AnimationController _animationController2;

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
    _animationController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5000), // Slow down the animation
    )..repeat();

    _animationController2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 10000), // Slow down the animation
    )..repeat();
  }

  @override
  void dispose() {
    _animationController1.dispose();
    _animationController2.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    if (page > _previousPage) {
      // Paginating forward
      _animationController1.duration = Duration(milliseconds: 500);
      _animationController2.duration = Duration(milliseconds: 1000);
      _animationController1.forward(from: 0.0);
      _animationController2.forward(from: 0.0);
    } else if (page < _previousPage) {
      // Paginating backward
      _animationController1.duration = Duration(milliseconds: 500);
      _animationController2.duration = Duration(milliseconds: 1000);
      _animationController1.reverse(from: 1.0);
      _animationController2.reverse(from: 1.0);
    }

    // Slow down the animation after pagination
    Future.delayed(Duration(milliseconds: 1000), () {
      _animationController1.duration = Duration(milliseconds: 5000);
      _animationController2.duration = Duration(milliseconds: 10000);
    });

    _previousPage = page; // Update the previous page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated Background with WavePainter
          AnimatedBuilder(
            animation: Listenable.merge([_animationController1, _animationController2]),
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(
                  _animationController1.value * 2 * 3.14,
                  _animationController2.value * 2 * 3.14,
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
              // Pagination Dots or Get Started Button
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  height: 60, // Fixed height to reserve space
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(scale: animation, child: child),
                        );
                      },
                      child: _currentPage == onboardingData.length - 1
                          ? ElevatedButton(
                              key: ValueKey('GetStartedButton'),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignInScreen()),
                                );
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
                                'Get Started',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : Row(
                              key: ValueKey('PaginationDots'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                onboardingData.length,
                                (index) => _buildDot(index),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
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
            Icon(
              onboardingData[index]['icon'],
              size: 100,
              color: Colors.white,
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
                fontSize: 16),
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
}