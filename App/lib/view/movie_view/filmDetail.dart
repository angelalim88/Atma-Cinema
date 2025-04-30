import 'package:flutter/material.dart';
import 'package:flutter_application_1/utilities/constant.dart';
import 'package:flutter_application_1/data/film.dart';
import 'package:flutter_application_1/view/movie_view/selectCinema.dart';
import 'package:flutter_application_1/view/ratings_view/listReview.dart';
import 'package:url_launcher/url_launcher.dart';

class FilmDetail extends StatelessWidget {
  final Film film;
  final Map<String, dynamic> userData;

  const FilmDetail({required this.film, required this.userData, Key? key})
      : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Movies",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor:
          const Color(0xFF161616), // Set background for entire Scaffold
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeroSection(size),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  _buildTitleSection(size),
                  const SizedBox(height: 20),
                  _buildSynopsisSection(),
                  const SizedBox(height: 16),
                  _buildDetailsSection(),
                  const SizedBox(height: 20),
                  _buildRatingsAndReviews(context),
                  const SizedBox(height: 20),
                  _buildBookNowButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(Size size) {
    return Stack(
      children: [
        // Full-width Image
        ClipRRect(
          borderRadius: BorderRadius.zero, // Remove borderRadius for full width
          child: Image.network(
            film.poster_2!,
            fit: BoxFit.cover,
            width: size.width, // Full-width image
            height: size.height * 0.30, // Adjust height as needed
          ),
        ),
        // Positioned Watch Trailer Button
        Positioned(
          bottom: 8,
          right: 8,
          child: ElevatedButton.icon(
            onPressed: () async {
              if (film.trailer != null && film.trailer!.isNotEmpty) {
                final Uri url = Uri.parse(film.trailer!);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  debugPrint("Cannot launch trailer URL");
                }
              }
            },
            icon: const Icon(Icons.play_arrow, color: Colors.white),
            label: const Text(
              "Watch Trailer",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.7),
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(Size size) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [Colors.yellow.shade600, Colors.orange.shade400],
        ).createShader(bounds);
      },
      child: Text(
        film.judul!,
        style: TextStyle(
          fontSize: size.width * 0.07,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSynopsisSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26, // Tetapkan warna latar yang sesuai
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Synopsis",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            film.deskripsi!,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          _buildFilmDetail("Genre", film.genre ?? "N/A", Icons.movie),
          _buildDivider(),
          _buildFilmDetail("Cast", film.aktor ?? "Unknown", Icons.people),
          _buildDivider(),
          _buildFilmDetail("Release Year",
              film.tahun_rilis?.toString() ?? "Unknown", Icons.calendar_today),
          _buildDivider(),
          _buildFilmDetail(
              "Director", film.sutradara ?? "Unknown", Icons.camera),
        ],
      ),
    );
  }

  Widget _buildFilmDetail(String title, String content, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: lightColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(color: Colors.white24, height: 1),
    );
  }

  Widget _buildRatingsAndReviews(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the Ratings & Reviews page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RatingsAndReviewsView(
              film: film,
              userData: userData,
            ), // Panggil RatingsAndReviewsView
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Ratings & Reviews",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    dynamic rating = film.rating ?? 0.0;
                    if (rating >= index + 1) {
                      return const Icon(Icons.star,
                          color: Colors.amber, size: 30);
                    } else if (rating > index && rating < index + 1) {
                      return const Icon(Icons.star_half,
                          color: Colors.amber, size: 30);
                    } else {
                      return const Icon(Icons.star_border,
                          color: Colors.amber, size: 30);
                    }
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  '${film.rating?.toStringAsFixed(1) ?? "0.0"} / 5',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Positioned(
              top: 8,
              right: 8,
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookNowButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SelectCinema(film: film, userData: userData,)),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFCC434),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.local_activity, // You can replace this with any other icon
            color: Colors.black, // Set the icon color to black
          ),
          SizedBox(width: 8), // Adds some space between the icon and text
          Text(
            "Book Now",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Set the text color to black
            ),
          ),
        ],
      ),
    );
  }
}
