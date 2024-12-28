import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _imagePaths = [
    'assets/images/the_shawshank_redemption.png',
    'assets/images/inception.png',
    'assets/images/interstellar.png',
    'assets/images/lord_of_the_rings.png',
  ];

  @override
  void initState() {
    super.initState();
    _startImageSlider();
  }

  void _startImageSlider() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = (_currentPage + 1) % _imagePaths.length;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
      _startImageSlider();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _imagePaths.length,
            itemBuilder: (context, index) {
              return Image.asset(
                _imagePaths[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Movie App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Vaše platforma na filmy',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    if (auth.isLoading)
                      const CircularProgressIndicator()
                    else if (auth.loginState == LoginState.initial)
                      _buildCustomButton(
                        text: 'Přihlásit se',
                        gradientColors: [
                          const Color(0xFF0062E6),
                          const Color(0xFF33AEFF),
                        ],
                        onPressed: () async {
                          await auth.requestSignIn();
                        },
                      )
                    else if (auth.loginState == LoginState.awaitingConfirmation)
                      _buildCustomButton(
                        text: 'Potvrdit přihlášení',
                        gradientColors: [
                          const Color(0xFF43A047),
                          const Color(0xFF66BB6A),
                        ],
                        onPressed: () async {
                          await auth.confirmLogin();
                        },
                      ),
                    if (auth.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          auth.error!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton({
    required String text,
    required List<Color> gradientColors,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
