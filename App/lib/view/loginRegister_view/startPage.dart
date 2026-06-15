import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_application_1/client/FilmClient.dart';
import 'package:flutter_application_1/data/film.dart';
import 'package:flutter_application_1/view/loginRegister_view/login.dart';
import 'package:flutter_application_1/view/loginRegister_view/register.dart';

class StartPageView extends StatefulWidget {
  const StartPageView({super.key});

  @override
  State<StartPageView> createState() => _StartPageViewState();
}

class _StartPageViewState extends State<StartPageView> {
  late final Future<List<Film>> _filmsFuture;

  @override
  void initState() {
    super.initState();
    _filmsFuture = FilmClient().fetchAll();
  }

  Widget _buildPoster(Film film) {
    final posterUrl = film.poster_1;

    if (posterUrl == null || posterUrl.isEmpty) {
      return Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFFFCC434), Color(0xFF2A2A2A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              film.judul ?? 'Now Playing',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Image.network(
        posterUrl,
        width: 300,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFF2A2A2A),
            ),
            child: const Icon(
              Icons.local_movies,
              color: Colors.white,
              size: 56,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo and "Now Playing!" Text
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Align logo closer to the left
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 0), // Adjusted for closer left alignment
                      child: SizedBox(
                        width: 150,
                        height: 100,
                        child: Image.asset(
                          'images/loadLogo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Center-aligned "Now Playing!" text
                  const Text(
                    'Now Playing!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Main Carousel
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: FutureBuilder<List<Film>>(
                future: _filmsFuture,
                builder: (context, snapshot) {
                  final nowPlaying = snapshot.data
                          ?.where((film) => film.status == 'Now Playing')
                          .toList() ??
                      [];

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: 300,
                      height: 300,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xFF2A2A2A),
                      ),
                      child: const CircularProgressIndicator(
                        color: Color(0xFFFCC434),
                      ),
                    );
                  }

                  if (nowPlaying.isEmpty) {
                    return Container(
                      width: 300,
                      height: 300,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xFF2A2A2A),
                      ),
                      child: const Text(
                        'Now Playing',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  return CarouselSlider.builder(
                    itemCount: nowPlaying.length,
                    options: CarouselOptions(
                      height: 300,
                      viewportFraction: 0.8,
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                    itemBuilder: (context, index, realIndex) {
                      return _buildPoster(nowPlaying[index]);
                    },
                  );
                },
              ),
            ),

            // Main Title
            const Text(
              'Best Cinema in Town',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Subtitle
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'feel the best cinema experience with lots of promo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),

            // Spacer for alignment
            const Spacer(),

            // Login and Register Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFFCC434), // Set to #FCC434
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(84), // Radius set to 84
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16), // Increase button height
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginView()),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(84), // Radius set to 84
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16), // Increase button height
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterView()),
                        );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Footer Text
            const Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Text(
                'By sign in or sign up, you agree to our Terms of Service and Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
